#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=Azure/kubelogin
KUBELOGIN_VERSION="0.2.15"

curl -fsSL "https://github.com/Azure/kubelogin/releases/download/v${KUBELOGIN_VERSION}/kubelogin-linux-amd64.zip" \
  -o /tmp/kubelogin.zip
unzip -o /tmp/kubelogin.zip -d /tmp/kubelogin
mv /tmp/kubelogin/bin/linux_amd64/kubelogin /usr/bin/kubelogin
chmod +x /usr/bin/kubelogin
rm -rf /tmp/kubelogin /tmp/kubelogin.zip
