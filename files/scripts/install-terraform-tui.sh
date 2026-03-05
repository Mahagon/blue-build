#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=idoavrah/terraform-tui
TERRAFORM_TUI_VERSION="0.13.5"

echo "Installing terraform-tui ${TERRAFORM_TUI_VERSION}..."
curl -fsSL "https://github.com/idoavrah/terraform-tui/releases/download/v${TERRAFORM_TUI_VERSION}/terraform-tui_Linux_x86_64.tar.gz" \
  -o /tmp/terraform-tui.tar.gz
tar xzf /tmp/terraform-tui.tar.gz -C /tmp tftui
mv /tmp/tftui /usr/bin/tftui
chmod +x /usr/bin/tftui
rm -f /tmp/terraform-tui.tar.gz
