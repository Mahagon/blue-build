#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=mvdan/sh
SHFMT_VERSION="3.13.0"

echo "Installing shfmt ${SHFMT_VERSION}..."
curl -fsSL "https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_amd64" \
  -o /usr/bin/shfmt
chmod +x /usr/bin/shfmt
