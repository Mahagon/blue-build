#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=anomalyco/opencode
OPENCODE_VERSION="1.17.14"

echo "Installing opencode ${OPENCODE_VERSION}..."
curl -fsSL "https://github.com/anomalyco/opencode/releases/download/v${OPENCODE_VERSION}/opencode-linux-x64.tar.gz" \
  -o /tmp/opencode.tar.gz
tar -xzf /tmp/opencode.tar.gz -C /usr/bin opencode
chmod +x /usr/bin/opencode
rm -f /tmp/opencode.tar.gz
