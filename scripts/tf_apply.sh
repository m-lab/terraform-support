#!/bin/bash
#
# tf_apply.sh rolls out google_compute_instance changes ONE VM AT A TIME, to
# avoid Terraform destroying and recreating a large swath of the virtual fleet
# simultaneously (which would disrupt the platform). It should be run from the
# repository root.
#
# How it works (see m-lab/terraform-support#61 for the history):
#
# The boot-disk resources declare `lifecycle { ignore_changes = [image] }` (and
# platform_instances ignore machine_type), so a plain `terraform apply` is
# structurally incapable of mass-recreating VMs when the image or machine type
# changes. That makes a normal apply safe, but it also means Terraform's own
# plan can no longer tell us which VMs still need the new image. So this script
# discovers stale VMs itself, entirely from Terraform's own data:
#
#   desired image = the disk_image variable (via `terraform console`)
#   actual image  = each boot disk's recorded image (via `terraform show -json`)
#
# For every boot disk whose recorded image does not match the desired image, we
# force just that one instance to be recreated with `terraform apply -replace`
# (a FULL, untargeted plan that additionally replaces the named resources — not
# `-target`, which Terraform warns against because it applies a partial plan).
# After each VM we wait for it to become healthy before moving to the next.
#
# Because the trigger is a state-vs-config comparison, a partial run is
# resumable for free: re-running only re-replaces disks that are still stale.
#
# Capacity note: a single transient "zone does not have enough resources"
# failure is retried for that one VM (see apply_with_capacity_retry). ANY other
# failure aborts the whole run, on purpose: we cannot know why an unexpected
# failure happened, and must not risk churning the rest of the fleet.

set -euxo pipefail

PROJECT=${1:? Please provide a project name}

# Number of times to retry a single VM whose create fails purely because its
# zone is temporarily out of capacity.
CAPACITY_RETRY_MAX=5

# apply_with_capacity_retry runs `terraform apply <args>` and, ONLY when it
# fails with a zone-capacity-exhaustion error, retries the same apply a few
# times with escalating backoff. Every other failure returns non-zero and, with
# `set -e`, aborts the script — preserving the fail-fast safety property.
function apply_with_capacity_retry() {
  local attempt=1
  local out
  local delay
  while true; do
    # `if out=$(...)` keeps `set -e` from aborting on a captured failure so we
    # can inspect the error text ourselves.
    if out=$(terraform apply -auto-approve -compact-warnings -no-color "$@" 2>&1); then
      echo "${out}"
      return 0
    fi
    echo "${out}"
    if grep -qE 'ZONE_RESOURCE_POOL_EXHAUSTED|does not have enough resources' <<<"${out}" \
        && (( attempt < CAPACITY_RETRY_MAX )); then
      delay=$(( attempt * 60 ))
      echo "### Zone capacity exhausted; retry ${attempt}/${CAPACITY_RETRY_MAX} in ${delay}s ..."
      sleep "${delay}"
      attempt=$(( attempt + 1 ))
      continue
    fi
    # Non-capacity error, or capacity retries exhausted: abort.
    return 1
  done
}

# update_instances rolls every stale VM of a given target ("api" or "platform")
# to the desired image, one at a time, waiting for health between each.
function update_instances() {
  local target=$1
  local desired_expr disk_res inst_res addr_res health_path
  local desired_image state_json idx ip status

  if [[ ${target} == "api" ]]; then
    desired_expr='var.api_instances.machine_attributes.disk_image'
    disk_res='module.platform-cluster.google_compute_disk.api_boot_disks'
    inst_res='module.platform-cluster.google_compute_instance.api_instances'
    addr_res='module.platform-cluster.google_compute_address.api_external_addresses'
    health_path="6443/readyz"
  else
    desired_expr='var.instances.attributes.disk_image'
    disk_res='module.platform-cluster.google_compute_disk.platform_boot_disks'
    inst_res='module.platform-cluster.google_compute_instance.platform_instances'
    addr_res='module.platform-cluster.google_compute_address.platform_addresses'
    health_path="443"
  fi

  # Desired image (short name), straight from Terraform's variables.
  desired_image=$(echo "${desired_expr}" | terraform console | tr -d '"')

  # Snapshot current state once.
  state_json=$(terraform show -json)

  # Indexes of boot disks whose recorded image does not end with the desired
  # short name (state stores a full projects/.../images/<name> URL). These are
  # the VMs still needing the new image. Collect into an array so the health
  # loop below does not run in a pipe subshell.
  local stale=()
  while IFS= read -r idx; do
    [[ -n ${idx} ]] && stale+=("${idx}")
  done < <(
    jq -r --arg res "${disk_res}" --arg want "${desired_image}" '
      [ .. | objects
        | select(.type? == "google_compute_disk")
        | select(.address? // "" | startswith($res)) ]
      | .[]
      | select((.values.image // "") | endswith($want) | not)
      | .index
    ' <<<"${state_json}"
  )

  if (( ${#stale[@]} == 0 )); then
    echo "### ${target}: all boot disks already on ${desired_image}; nothing to roll."
    return 0
  fi
  echo "### ${target}: ${#stale[@]} VM(s) to roll to ${desired_image}: ${stale[*]}"

  for idx in "${stale[@]}"; do
    # Stable reserved external IP for the health check (survives VM replacement).
    ip=$(jq -r --arg res "${addr_res}" --arg i "${idx}" '
      [ .. | objects
        | select(.type? == "google_compute_address")
        | select(.address? // "" | startswith($res))
        | select(.index? == $i) ]
      | .[0].values.address // ""
    ' <<<"${state_json}")

    echo "### Rolling ${target} VM ${idx} (${ip}) to ${desired_image}"
    # Replace both the boot disk and the instance. Replacing the disk alone
    # would cascade to the instance anyway (boot_disk.source is force-new), but
    # naming both is self-documenting and robust.
    apply_with_capacity_retry \
      -replace="${disk_res}[\"${idx}\"]" \
      -replace="${inst_res}[\"${idx}\"]"

    # Wait until the VM is serving before moving on. API: /readyz on 6443;
    # platform: ndt-server on 443.
    status=""
    until [[ ${status} == "200" ]]; do
      sleep 5
      status=$(
        curl --insecure --output /dev/null --silent --write-out "%{http_code}" \
          "https://${ip}:${health_path}" \
          || true
      )
    done
  done
}

function main() {
  cd "${PROJECT}"

  # The environment is clean on every build in Cloud Build, so we need to run
  # this to download the required providers.
  terraform init

  # We only want to iterate over instances in the M-Lab Platform clusters, which
  # only exist on our main three sandbox->staging->prod GCP projects. API
  # instances go first, since everything else depends on the control plane.
  case "${PROJECT}" in
    mlab-sandbox | mlab-staging | mlab-oti)
      for target in api platform; do
        update_instances "${target}"
      done
      ;;
    *)
      # Do nothing.
      ;;
  esac

  # Apply everything else. With ignore_changes on the boot-disk image (and
  # platform machine_type), this can no longer mass-recreate the VM fleet, so it
  # is safe to run untargeted. It does still replace the prometheus VM by itself
  # on an image bump (prometheus_boot_disk is intentionally not ignored), and it
  # recreates any instance that is missing from the cloud (e.g. a VM left down
  # by a prior aborted roll) — both single-VM changes. Wrap it in the same
  # capacity retry so a transient zone shortage during those creates does not
  # fail the whole run; every other error still aborts.
  apply_with_capacity_retry
}

main
