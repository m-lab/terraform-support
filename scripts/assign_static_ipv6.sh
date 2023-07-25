#!/bin/bash
#
# A small shell script which will remove an ephemeral IPv6 address from an
# instance and reassign a static IPv6 to the same instance. This is a temporary
# helper script which is run as a local-exec provisioner when instances are
# [re]created by TF. GCP supports static regional IPv6 addresses, but the Google
# Terraform provider does not yet support this.

set -euxo pipefail

PROJECT=${1? The first argument must be the GCP project}

shift

for m in $@; do
  machine="${m}-${PROJECT}-measurement-lab-org"
  zone=$(
	gcloud compute instances list --filter "name:$machine" \
	  --format "value(zone)" \
	  --project $PROJECT
  )

  # First make sure that the static address exists. The static address may not
  # exist if this VM was just created for the first time.
  existing_addr=$(
	gcloud compute addresses list --filter "name:${machine}-v6" \
	  --format "value(address)" \
	  --project $PROJECT
  )

  # If the static address doesn't exist, then create it.
  if [[ -z $existing_addr ]]; then
    gcloud compute addresses create "${machine}-v6" \
	  --region ${zone%-*} \
	  --subnet "kubernetes" \
	  --ip-version "IPV6" \
	  --endpoint-type "VM" \
	  --project $PROJECT
  fi

  # This step effectively removes the ephemeral IPv6 address of the machine by
  # specifying IPV4_ONLY. After which we add the existing static IPv6 address.
  # This way of doing things comes directly from the Google documentation:
  # https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address#IP_assign
  gcloud compute instances network-interfaces update $machine \
    --network-interface=nic0 \
	--stack-type=IPV4_ONLY \
	--zone=$zone \
	--project=$PROJECT

  gcloud compute instances network-interfaces update $machine \
    --network-interface=nic0 \
	--ipv6-network-tier=PREMIUM \
	--stack-type=IPV4_IPV6 \
	--external-ipv6-address="${machine}-v6" \
    --external-ipv6-prefix-length=96 \
	--zone=$zone \
	--project=$PROJECT
done
