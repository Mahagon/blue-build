#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=idoavrah/terraform-tui
TERRAFORM_TUI_VERSION="0.13.5"

echo "Installing terraform-tui ${TERRAFORM_TUI_VERSION}..."
pip install --quiet "tftui==${TERRAFORM_TUI_VERSION}"
