#!/bin/bash
#
# Startup script for the autonode-deb VM: makes it track the mlab-node APT
# repository in this project (Artifact Registry) and upgrade automatically.
# Startup scripts run on every boot, so everything here is idempotent.
#
# Node configuration (/etc/mlab/*.env) is not handled here: the byos-debian
# deploy pipeline writes it, and the package preserves it across upgrades.
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

PROJECT=$(curl -sf -H 'Metadata-Flavor: Google' \
  http://metadata.google.internal/computeMetadata/v1/project/project-id)
AR_URL="https://us-central1-apt.pkg.dev"

# Downloads a signing key into /etc/apt/keyrings, dearmoring it if needed.
fetch_key() {
  local url=$1 dest=$2
  curl -fsSL "${url}" -o "${dest}.tmp"
  if grep -q 'BEGIN PGP PUBLIC KEY BLOCK' "${dest}.tmp"; then
    gpg --dearmor --batch --yes -o "${dest}" "${dest}.tmp"
    rm -f "${dest}.tmp"
  else
    mv "${dest}.tmp" "${dest}"
  fi
  chmod 0644 "${dest}"
}

install -d -m 0755 /etc/apt/keyrings

# apt-transport-artifact-registry lets apt authenticate to Artifact Registry
# as the VM's service account (the repository is private).
fetch_key https://packages.cloud.google.com/apt/doc/apt-key.gpg \
  /etc/apt/keyrings/cloud.google.gpg
echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt apt-transport-artifact-registry-stable main" \
  > /etc/apt/sources.list.d/artifact-registry.list
apt-get update
apt-get install -y apt-transport-artifact-registry

# The mlab-node repository. Artifact Registry signs the repository metadata
# with its own key; the transport only handles authentication.
fetch_key "${AR_URL}/doc/repo-signing-key.gpg" /etc/apt/keyrings/artifact-registry.gpg
echo "deb [signed-by=/etc/apt/keyrings/artifact-registry.gpg] ar+${AR_URL}/projects/${PROJECT} mlab-node main" \
  > /etc/apt/sources.list.d/mlab-node.list

# Periodic upgrade. The package's postinst restarts mlab-node.target on
# upgrade (graceful, draining in-flight tests), so no restart logic is needed
# here. --only-upgrade is a no-op until the deploy pipeline has installed and
# configured the package.
cat > /etc/systemd/system/mlab-node-upgrade.service <<'EOF'
[Unit]
Description=Upgrade mlab-node from the Artifact Registry APT repository
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
Environment=DEBIAN_FRONTEND=noninteractive
ExecStart=/usr/bin/apt-get update
ExecStart=/usr/bin/apt-get install -y --only-upgrade mlab-node
EOF

cat > /etc/systemd/system/mlab-node-upgrade.timer <<'EOF'
[Unit]
Description=Periodic mlab-node upgrade check

[Timer]
OnBootSec=5min
OnUnitActiveSec=15min
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now mlab-node-upgrade.timer
