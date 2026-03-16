#!/usr/bin/env bash
set -euo pipefail

echo "Installing Hytale Launcher..."
curl -fsSL "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak" \
  -o /tmp/hytale-launcher.flatpak
flatpak install --system --noninteractive /tmp/hytale-launcher.flatpak
rm -f /tmp/hytale-launcher.flatpak
