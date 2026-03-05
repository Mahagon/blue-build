#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=idoavrah/terraform-tui
TERRAFORM_TUI_VERSION="0.13.4"

echo "Installing terraform-tui ${TERRAFORM_TUI_VERSION}..."
python3 -m venv /opt/tftui
/opt/tftui/bin/pip install --quiet "tftui==${TERRAFORM_TUI_VERSION}"
ln -s /opt/tftui/bin/tftui /usr/bin/tftui
