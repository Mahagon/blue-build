#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=pypi depName=headroom-ai
HEADROOM_VERSION="0.27.0"

echo "Installing headroom ${HEADROOM_VERSION}..."
pip install --no-cache-dir "headroom-ai==${HEADROOM_VERSION}"
headroom --version
