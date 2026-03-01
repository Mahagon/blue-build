#!/usr/bin/env bash
set -euo pipefail

HELMFILE_VERSION="1.3.2"
mkdir -p /usr/local/bin
curl -fsSL "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz" \
  | tar xz -C /usr/local/bin helmfile
chmod +x /usr/local/bin/helmfile
