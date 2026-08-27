#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=kubernetes-sigs/kind
KIND_VERSION="0.33.0"

echo "Installing kind ${KIND_VERSION}..."
curl -fsSL "https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/kind-linux-amd64" \
  -o /usr/bin/kind
curl -fsSL "https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/kind-linux-amd64.sha256sum" \
  -o /tmp/kind.sha256sum
echo "$(awk '{print $1}' /tmp/kind.sha256sum)  /usr/bin/kind" | sha256sum --check
chmod +x /usr/bin/kind
rm -f /tmp/kind.sha256sum
