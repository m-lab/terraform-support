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

# Downloads a signing key into /etc/apt/keyrings and prints its path. apt
# accepts ASCII-armored keys in signed-by= as long as the file ends in .asc,
# so no gpg (absent from ubuntu-minimal) is needed to dearmor.
fetch_key() {
  local url=$1 name=$2 tmp dest
  tmp=$(mktemp)
  curl -fsSL "${url}" -o "${tmp}"
  if grep -q 'BEGIN PGP PUBLIC KEY BLOCK' "${tmp}"; then
    dest="/etc/apt/keyrings/${name}.asc"
  else
    dest="/etc/apt/keyrings/${name}.gpg"
  fi
  install -m 0644 "${tmp}" "${dest}"
  rm -f "${tmp}"
  echo "${dest}"
}

install -d -m 0755 /etc/apt/keyrings

# apt-transport-artifact-registry lets apt authenticate to Artifact Registry
# as the VM's service account (the repository is private).
KEY=$(fetch_key https://packages.cloud.google.com/apt/doc/apt-key.gpg cloud.google)
echo "deb [signed-by=${KEY}] https://packages.cloud.google.com/apt apt-transport-artifact-registry-stable main" \
  > /etc/apt/sources.list.d/artifact-registry.list
apt-get update
apt-get install -y apt-transport-artifact-registry

# The mlab-node repository. Artifact Registry signs the repository metadata
# with its own key; the transport only handles authentication.
KEY=$(fetch_key "${AR_URL}/doc/repo-signing-key.gpg" artifact-registry)
echo "deb [signed-by=${KEY}] ar+${AR_URL}/projects/${PROJECT} mlab-node main" \
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
