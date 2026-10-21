#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=npm depName=@opencode/cli-linux-x64
OPENCODE_VERSION="2.1.2"

echo "Installing opencode ${OPENCODE_VERSION}..."
curl -fsSL "https://registry.npmjs.org/@opencode/cli-linux-x64/-/cli-linux-x64-${OPENCODE_VERSION}.tgz" \
  -o /tmp/opencode.tgz
tar -xzf /tmp/opencode.tgz -C /tmp package/bin/opencode
mv /tmp/package/bin/opencode /usr/bin/opencode
chmod +x /usr/bin/opencode
rm -rf /tmp/opencode.tgz /tmp/package
