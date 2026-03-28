#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=mikefarah/yq
YQ_VERSION="4.52.5"

echo "Installing yq ${YQ_VERSION}..."
curl -fsSL "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" \
  -o /tmp/yq
curl -fsSL "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/checksums" \
  -o /tmp/yq-checksums.txt
echo "$(grep "^yq_linux_amd64 " /tmp/yq-checksums.txt | awk '{print $19}')  /tmp/yq" \
  | sha256sum --check
mv /tmp/yq /usr/bin/yq
chmod +x /usr/bin/yq
rm -f /tmp/yq-checksums.txt
