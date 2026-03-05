#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=containers/podman-tui
PODMAN_TUI_VERSION="1.10.0"

echo "Installing podman-tui ${PODMAN_TUI_VERSION}..."
curl -fsSL "https://github.com/containers/podman-tui/releases/download/v${PODMAN_TUI_VERSION}/podman-tui_v${PODMAN_TUI_VERSION}_linux_amd64.tar.gz" \
  -o /tmp/podman-tui.tar.gz
tar xzf /tmp/podman-tui.tar.gz -C /tmp podman-tui
mv /tmp/podman-tui /usr/bin/podman-tui
chmod +x /usr/bin/podman-tui
rm -f /tmp/podman-tui.tar.gz
