#!/bin/bash
#
# A small shell script which will remove an ephemeral IPv6 address from an
# instance and reassign a static IPv6 to the same instance. This is a temporary
# helper script which will need to be run manually when instances are destroyed
# and recreated. GCP supports static regional IPv6 addresses, but the Google
# Terraform provider does not yet support this.

set -euxo pipefail

PROJECT=${1? The first argument must be the GCP project}

shift

for m in $@; do
  machine="${m}-${PROJECT}-measurement-lab-org"
  zone=$(
	gcloud compute instances list --project $PROJECT --filter "name:$m" --format "value(zone)"
  )

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
