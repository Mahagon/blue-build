#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=npm depName=prettier
PRETTIER_VERSION="3.8.2"

echo "Installing prettier ${PRETTIER_VERSION}..."
npm install -g --prefix /usr "prettier@${PRETTIER_VERSION}"
ls -la /usr/bin/prettier
