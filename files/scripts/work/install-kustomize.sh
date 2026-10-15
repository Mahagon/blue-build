#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=kubernetes-sigs/kustomize extractVersion=^kustomize/v(?<version>.+)$
KUSTOMIZE_VERSION="5.8.3"

echo "Installing kustomize ${KUSTOMIZE_VERSION}..."
BASE_URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}"
curl -fsSL "${BASE_URL}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" -o /tmp/kustomize.tar.gz
curl -fsSL "${BASE_URL}/checksums.txt" -o /tmp/kustomize-checksums.txt
echo "$(grep "kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" /tmp/kustomize-checksums.txt | awk '{print $1}')  /tmp/kustomize.tar.gz" \
  | sha256sum --check
tar xzf /tmp/kustomize.tar.gz -C /usr/bin kustomize
chmod +x /usr/bin/kustomize
rm -f /tmp/kustomize.tar.gz /tmp/kustomize-checksums.txt
