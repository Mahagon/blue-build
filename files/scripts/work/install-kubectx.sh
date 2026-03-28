#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=ahmetb/kubectx
KUBECTX_VERSION="0.11.0"

echo "Installing kubectx ${KUBECTX_VERSION}..."
curl -fsSL "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz" \
  -o /tmp/kubectx.tar.gz
curl -fsSL "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens_v${KUBECTX_VERSION}_linux_x86_64.tar.gz" \
  -o /tmp/kubens.tar.gz
curl -fsSL "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/checksums.txt" \
  -o /tmp/kubectx-checksums.txt
echo "$(grep "kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz" /tmp/kubectx-checksums.txt | awk '{print $1}')  /tmp/kubectx.tar.gz" \
  | sha256sum --check
echo "$(grep "kubens_v${KUBECTX_VERSION}_linux_x86_64.tar.gz" /tmp/kubectx-checksums.txt | awk '{print $1}')  /tmp/kubens.tar.gz" \
  | sha256sum --check
tar xzf /tmp/kubectx.tar.gz -C /usr/bin kubectx
tar xzf /tmp/kubens.tar.gz -C /usr/bin kubens
chmod +x /usr/bin/kubectx /usr/bin/kubens
rm -f /tmp/kubectx.tar.gz /tmp/kubens.tar.gz /tmp/kubectx-checksums.txt
