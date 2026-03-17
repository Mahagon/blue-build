#!/usr/bin/env bash
set -euxo pipefail

echo "Downloading Hytale Launcher flatpak bundle..."
curl -fsSL "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak" \
  -o /usr/share/hytale-launcher.flatpak
ls -la /usr/share/hytale-launcher.flatpak
