#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=pypi depName=headroom-ai
HEADROOM_VERSION="0.36.4"

echo "Installing headroom ${HEADROOM_VERSION}..."
python3 -m pip install --break-system-packages --ignore-installed "headroom-ai==${HEADROOM_VERSION}"
headroom --version
