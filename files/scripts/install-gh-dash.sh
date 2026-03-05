#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=dlvhdr/gh-dash
GH_DASH_VERSION="4.23.0"

echo "Installing gh-dash ${GH_DASH_VERSION}..."
curl -fsSL "https://github.com/dlvhdr/gh-dash/releases/download/v${GH_DASH_VERSION}/gh-dash_Linux_x86_64.tar.gz" \
  -o /tmp/gh-dash.tar.gz
tar xzf /tmp/gh-dash.tar.gz -C /tmp gh-dash
mv /tmp/gh-dash /usr/bin/gh-dash
chmod +x /usr/bin/gh-dash
rm -f /tmp/gh-dash.tar.gz
