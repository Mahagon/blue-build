#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=vmware-tanzu/velero
VELERO_VERSION="1.18.2"

echo "Installing velero ${VELERO_VERSION}..."
curl -fsSL "https://github.com/vmware-tanzu/velero/releases/download/v${VELERO_VERSION}/velero-v${VELERO_VERSION}-linux-amd64.tar.gz" \
  -o /tmp/velero.tar.gz
curl -fsSL "https://github.com/vmware-tanzu/velero/releases/download/v${VELERO_VERSION}/CHECKSUM" \
  -o /tmp/velero-checksums.txt
echo "$(grep "velero-v${VELERO_VERSION}-linux-amd64.tar.gz" /tmp/velero-checksums.txt | awk '{print $1}')  /tmp/velero.tar.gz" \
  | sha256sum --check
tar xzf /tmp/velero.tar.gz -C /tmp "velero-v${VELERO_VERSION}-linux-amd64/velero"
mv "/tmp/velero-v${VELERO_VERSION}-linux-amd64/velero" /usr/bin/velero
chmod +x /usr/bin/velero
rm -rf /tmp/velero.tar.gz /tmp/velero-checksums.txt "/tmp/velero-v${VELERO_VERSION}-linux-amd64"
