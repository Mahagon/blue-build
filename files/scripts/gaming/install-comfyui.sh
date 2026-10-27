#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=Comfy-Org/ComfyUI
COMFYUI_VERSION="0.43.0"

echo "Installing ComfyUI ${COMFYUI_VERSION}..."
# Upstream publishes no checksum for the source; git verifies object integrity.
# Python dependencies (PyTorch ROCm) are installed per user by /usr/bin/comfyui.
rm -rf /tmp/comfyui /usr/lib/comfyui
git clone --depth 1 --branch "v${COMFYUI_VERSION}" https://github.com/Comfy-Org/ComfyUI.git /tmp/comfyui
rm -rf /tmp/comfyui/.git
mv /tmp/comfyui /usr/lib/comfyui
