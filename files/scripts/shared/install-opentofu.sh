#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=opentofu/opentofu
OPENTOFU_VERSION="1.13.0"

echo "Installing opentofu ${OPENTOFU_VERSION}..."
curl -fsSL "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_linux_amd64.tar.gz" \
  -o /tmp/tofu.tar.gz
curl -fsSL "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_SHA256SUMS" \
  -o /tmp/tofu-checksums.txt
echo "$(grep " tofu_${OPENTOFU_VERSION}_linux_amd64.tar.gz$" /tmp/tofu-checksums.txt | awk '{print $1}')  /tmp/tofu.tar.gz" \
  | sha256sum --check
tar -xzf /tmp/tofu.tar.gz -C /tmp tofu
mv /tmp/tofu /usr/bin/tofu
chmod +x /usr/bin/tofu
rm -f /tmp/tofu.tar.gz /tmp/tofu-checksums.txt
