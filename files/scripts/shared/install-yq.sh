#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=mikefarah/yq
YQ_VERSION="4.52.5"

echo "Installing yq ${YQ_VERSION}..."
curl -fsSL "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" \
  -o /usr/bin/yq
chmod +x /usr/bin/yq
ls -la /usr/bin/yq
