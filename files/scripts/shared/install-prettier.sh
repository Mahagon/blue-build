#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=npm depName=prettier
PRETTIER_VERSION="3.8.1"

echo "Installing prettier ${PRETTIER_VERSION}..."
npm install -g --prefix /usr "prettier@${PRETTIER_VERSION}"
