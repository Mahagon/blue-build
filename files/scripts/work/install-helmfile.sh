#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=helmfile/helmfile
HELMFILE_VERSION="1.4.2"

echo "Installing helmfile ${HELMFILE_VERSION}..."
curl -fsSL "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz" \
  | tar xz -C /usr/bin helmfile
chmod +x /usr/bin/helmfile
