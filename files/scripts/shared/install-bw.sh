#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=bitwarden/clients extractVersion=^cli-v(?<version>.+)$
BW_VERSION="2026.1.0"

echo "Installing bw (Bitwarden CLI) ${BW_VERSION}..."
curl -fsSL "https://github.com/bitwarden/clients/releases/download/cli-v${BW_VERSION}/bw-linux-${BW_VERSION}.zip" \
  -o /tmp/bw.zip
echo "Downloaded $(stat -c%s /tmp/bw.zip) bytes"
unzip -p /tmp/bw.zip bw > /usr/bin/bw
chmod +x /usr/bin/bw
rm -f /tmp/bw.zip
ls -la /usr/bin/bw
