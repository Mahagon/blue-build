#!/usr/bin/env bash
set -euo pipefail

hytale_launcher_url="${HYTALE_LAUNCHER_URL:-https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak}"
hytale_bundle_path="${HYTALE_BUNDLE_PATH:-/usr/share/hytale-launcher.flatpak}"

mkdir -p "$(dirname "$hytale_bundle_path")"
rm -f "$hytale_bundle_path"
temporary_bundle="$(mktemp "${hytale_bundle_path}.tmp.XXXXXX")"
trap 'rm -f "$temporary_bundle"' EXIT

echo "Downloading Hytale Launcher flatpak bundle..."
if curl -fLsS --retry 5 --retry-all-errors "$hytale_launcher_url" -o "$temporary_bundle" \
  && [[ -s "$temporary_bundle" ]]; then
  chmod 0644 "$temporary_bundle"
  mv -f "$temporary_bundle" "$hytale_bundle_path"
  trap - EXIT
  echo "Hytale Launcher bundle staged at $hytale_bundle_path"
else
  echo "Warning: Hytale Launcher bundle could not be downloaded; continuing without it." >&2
fi
