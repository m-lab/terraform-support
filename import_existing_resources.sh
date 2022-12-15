#!/bin/bash
#
# Imports existing infrastructure into the terraform state.

PROJECT=${1:? Please provide a project name}

# A bash associative array. Pretend you didn't see this.
declare -A resource_id_templates=(
  ["google_compute_address"]="projects/{{project}}/regions/{{region}}/addresses/{{name}}"
  ["google_compute_disk"]="projects/{{project}}/zones/{{zone}}/disks/{{name}}"
  ["google_compute_instance"]="projects/{{project}}/zones/{{zone}}/instances/{{name}}"
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
