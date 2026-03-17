#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=dlvhdr/gh-dash
GH_DASH_VERSION="4.23.2"

echo "Installing gh-dash ${GH_DASH_VERSION}..."
curl -fsSL "https://github.com/dlvhdr/gh-dash/releases/download/v${GH_DASH_VERSION}/gh-dash_v${GH_DASH_VERSION}_linux-amd64" \
  -o /usr/bin/gh-dash
chmod +x /usr/bin/gh-dash
ls -la /usr/bin/gh-dash
