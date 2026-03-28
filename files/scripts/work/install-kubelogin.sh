#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=Azure/kubelogin
KUBELOGIN_VERSION="0.2.16"

echo "Installing kubelogin ${KUBELOGIN_VERSION}..."
curl -fsSL "https://github.com/Azure/kubelogin/releases/download/v${KUBELOGIN_VERSION}/kubelogin-linux-amd64.zip" \
  -o /tmp/kubelogin.zip
curl -fsSL "https://github.com/Azure/kubelogin/releases/download/v${KUBELOGIN_VERSION}/kubelogin-linux-amd64.zip.sha256" \
  -o /tmp/kubelogin-checksum.txt
echo "$(cat /tmp/kubelogin-checksum.txt)  /tmp/kubelogin.zip" \
  | sha256sum --check
unzip -o /tmp/kubelogin.zip -d /tmp/kubelogin
mv /tmp/kubelogin/bin/linux_amd64/kubelogin /usr/bin/kubelogin
chmod +x /usr/bin/kubelogin
rm -rf /tmp/kubelogin /tmp/kubelogin.zip /tmp/kubelogin-checksum.txt
