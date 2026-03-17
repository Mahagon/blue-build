#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=containers/podman-tui
PODMAN_TUI_VERSION="1.11.1"

echo "Installing podman-tui ${PODMAN_TUI_VERSION}..."
curl -fsSL "https://github.com/containers/podman-tui/releases/download/v${PODMAN_TUI_VERSION}/podman-tui-release-linux_amd64.zip" \
  -o /tmp/podman-tui.zip
echo "Downloaded $(stat -c%s /tmp/podman-tui.zip) bytes"
unzip -j /tmp/podman-tui.zip "podman-tui-release-linux_amd64/podman-tui-${PODMAN_TUI_VERSION}/podman-tui" -d /tmp
mv /tmp/podman-tui /usr/bin/podman-tui
chmod +x /usr/bin/podman-tui
rm -f /tmp/podman-tui.zip
ls -la /usr/bin/podman-tui
