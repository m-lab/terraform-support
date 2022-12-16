#!/bin/bash
#
# Imports existing infrastructure into the terraform state.
#
# Terraform will refuse to manage infrastructure that already exists for which it does
# not have state on. Each existing resource you want terraform to manage must be
# "imported" into terraform's state. This is a convenience script to automate
# bulk import of existing infrastruture. Once all infrastructure is under
# terraform control, this script will no longer be useful. The process looks
# something like:
#
# * Write terraform configs for existing infrastructure.
# * Run this script to import these resource into terraform's state.
# * Run `terraform apply` to apply any changes.

PROJECT=${1:? Please provide a project name}

# A bash associative array. Pretend you didn't see this.
declare -A resource_id_templates=(
  ["google_compute_address"]="projects/{{project}}/regions/{{region}}/addresses/{{name}}"
  ["google_compute_disk"]="projects/{{project}}/zones/{{zone}}/disks/{{name}}"
  ["google_compute_firewall"]="projects/{{project}}/global/firewalls/{{name}}"
  ["google_compute_forwarding_rule"]="projects/{{project}}/regions/{{region}}/forwardingRules/{{name}}"
  ["google_compute_instance"]="projects/{{project}}/zones/{{zone}}/instances/{{name}}"
  ["google_compute_network"]="projects/{{project}}/global/networks/{{name}}"
  ["google_compute_region_backend_service"]="projects/{{project}}/regions/{{region}}/backendServices/{{name}}"
  ["google_compute_health_check"]="projects/{{project}}/global/healthChecks/{{name}}"
  ["google_compute_subnetwork"]="projects/{{project}}/regions/{{region}}/subnetworks/{{name}}"
  ["google_storage_bucket"]="{{project}}/{{name}}"
)

pushd $PROJECT

terraform plan -out plan.tfplan > /dev/null

# base64 encode each change, in case there are newlines in the data.
for change in $(terraform show -json plan.tfplan | jq -r '.resource_changes[] | @base64'); do
  c=$(echo $change | base64 --decode)
  address=$(echo $c| jq -r '.address')
  name=$(echo $c| jq -r '.change.after.name')
  region=$(echo $c| jq -r '.change.after.region')
  resource_type=$(echo $c| jq -r '.type')
  zone=$(echo $c| jq -r '.change.after.zone')

  template=${resource_id_templates[$resource_type]}

  resource_id=$(
    echo $template | \
    sed -e "s/{{project}}/${PROJECT}/" \
        -e "s/{{region}}/${region}/" \
        -e "s/{{name}}/${name}/" \
        -e "s/{{zone}}/${zone}/"
  )

  # Import the resource if it doesn't exist in the current state. The following
  # command will exit with a status of 0 if the resource is in the current
  # state.
  terraform state show "${address}" &> /dev/null
  if [[ $? -ne 0 ]]; then
    terraform import "${address}" "${resource_id}"
  fi
done

rm plan.tfplan

popd
