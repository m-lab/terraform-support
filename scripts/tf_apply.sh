#!/bin/bash
#
# This script updates google_compute_instances one at a time, but only if they
# are being deleted then recreated, then applies all other changes. This is to
# avoid Terraform (TF) from more or less deleting and recreating all instances
# at once when a change is applied which affects all virtual machines e.g., a
# boot disk changes. This script should be run from the repository root.
#
# This script achieves a serial deployment of VM changes by utilizing the
# -target flag of TF, which causes TF to only consider the resources pointed at
# by -target flag(s). This usage of -target is highly discouraged by TF, and
# when running with this flag TF will emit warnings to this effect. However, we
# have not found another way to achieve a rolling update of resources,
# particularly of VMs.

set -euxo pipefail

PROJECT=${1:? Please provide a project name}

# update_instances() unconditionally iterates through instances and attempts to
# update them one at a time if the action is to recreate the instance.
function update_instances() {
  local c
  local changes
  local health_path
  local idx
  local ipv4
  local is_recreate
  local resource
  local status=""
  local target=$1
  local targets

  # Create and write out the plan.
  terraform plan -out instances.tfplan \
    -target "module.platform-cluster.google_compute_instance.${target}_instances" \
    > /dev/null

  # Perform the command substitution for `terraform show` in a variable
  # assignment in which case the exit code of the entire operation is subject
  # to the shopts set at the top of the file, meaning that if any command in
  # the pipe chain fails the script will exit.
  changes=$(terraform show -json instances.tfplan | jq -r '.resource_changes[] | @base64')
  for change in $changes; do
    c=$(echo $change | base64 -d)
    resource=$(echo $c | jq -r '.type')

    # We only care about google_compute_instance resources.
    if [[ $resource != "google_compute_instance" ]]; then
      continue
    fi

    # For API instances, unconditionally create or update them first, since
    # everything else depends on them. For regular platform VMs if the action
    # does not involve recreating an existing resource, but just creating a
    # non-existent resource, then move on, since our only concern is avoiding
    # mass deletion and recreation of existing google_compute_instance
    # resources, and related things like boot disks.
    if [[ $target != "api" ]]; then
      is_recreate=$(echo $c | jq -r 'any(.action_reason == "replace_because_cannot_update"; . == true )')
      if [[ $is_recreate != "true" ]]; then
        continue
      fi
    fi

    idx=$(echo $c | jq -r '.index')
    ipv4=$(echo $c | jq -r '.change.after.network_interface[0].access_config[0].nat_ip')

    # Target all of the resources associated with the instance so that Terraform
    # can order all operations properly.
    if [[ $target == "api" ]]; then
      health_path="6443/readyz"
      targets=" \
        -target module.platform-cluster.google_compute_instance.api_instances[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.api_boot_disks[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.api_data_disks[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.api_internal_addresses[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.api_external_addresses[\"${idx}\"] \
      "
    else
      health_path="443"
      targets=" \
        -target module.platform-cluster.google_compute_instance.platform_instances[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.platform_boot_disks[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.platform_addresses[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.platform_addresses_internal[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.platform_addresses_v6[\"${idx}\"] \
      "
    fi

    terraform apply -auto-approve -compact-warnings -no-color $targets

    # Wait until the machine is up and required services are running. For an API
    # server, this means that the /readyz endpoint returns 200. For platform
    # VMs, this means that ndt-server is up and running on port 443.
    until [[ $status == "200" ]]; do
      sleep 5
      status=$(
        curl --insecure --output /dev/null --silent --write-out "%{http_code}" \
          "https://${ipv4}:${health_path}" \
          || true
      )
    done

    # Reset status for next iteration.
    status=""

  done

  rm instances.tfplan
}

function main() {
  cd $PROJECT

  # The environment is clean on every build in Cloud Build, so we need to run
  # this to download the required providers.
  terraform init

  for target in api platform; do
    update_instances $target
  done

  # Now apply everything else.
  #
  # TODO(kinkade: there is room for improvement here. If the calls to
  # update_instances() above fail for some reason and changes to VMs do not get
  # applied one at a time, then the possibility exists that the following
  # command could unconditionally apply all changes at once. The virtual
  # machines should all recover, but it may cause unwanted downtime. Find a way
  # to not need this script, or to improve it to be a bit safer.
  terraform apply -auto-approve -compact-warnings -no-color
}

main

