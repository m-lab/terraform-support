#!/bin/bash
#
# A script which will update google_compute_instances one at a time with some
# delay between, then apply all other changes. This is to avoid Terraform from
# more or less deleting and recreating all instances at once when a change is
# applied which affects all virtual machines.

PROJECT=${1:? Please provide a project name}

# update_instances() unconditionally iterates through instances and attempt to
# update them one at a time. If no change is needed it is a no-op.
function update_instances() {
  local target=$1

  # Create and write out the plan.
  terraform plan -out instances.tfplan \
    -target "module.platform-cluster.google_compute_instance.${target}_instances" \
    > /dev/null

  for change in $(terraform show -json instances.tfplan | jq -r '.resource_changes[] | @base64'); do
    c=$(echo $change | base64 --decode)
    resource=$(echo $c | jq -r '.type')
    if [[ $resource != "google_compute_instance" ]]; then
      continue
    fi
    idx=$(echo $c | jq -r '.index')
    is_delete=$(echo $c | jq -r '.change.actions | any(index("delete"))')

    # Target all of the resources associated with the instance so that Terraform
    # can order all operations properly.
    if [[ $target == "api" ]]; then
      targets=" \
        -target module.platform-cluster.google_compute_instance.api_instances[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.api_boot_disks[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.api_data_disks[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.api_internal_addresses[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.api_extennal_addresses[\"${idx}\"] \
      "
    else
      targets=" \
        -target module.platform-cluster.google_compute_instance.platform_instances[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.platform_boot_disks[\"${idx}\"] \
        -target module.platform-cluster.google_compute_disk.platform_addresses[\"${idx}\"] \
      "
    fi

    terraform apply -auto-approve -compact-warnings $targets

    # The instance is created, but it still has to boot and join the cluster.
    # Give it a little time to do this. In my tests it takes roughly 2m for the
    # machine to join the cluster and become ready, and about another minute
    # before all pods are in a ready state. However, if the the instance isn't
    # being deleted and recreated but just updated in place, then continue
    # immediately.
    if [[ $is_delete == "true" ]]; then
      sleep 180
    fi
  done

  rm instances.tfplan
}

function main() {
  pushd ../$PROJECT

  for target in api platform; do
    update_instances $target
  done

  # Now apply everything else.
  terraform apply -auto-approve

  popd
}

main
