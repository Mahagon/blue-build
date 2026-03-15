#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=InioX/matugen
MATUGEN_VERSION="v4.0.0"

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)  BINARY="matugen-x86_64-unknown-linux-gnu" ;;
  aarch64) BINARY="matugen-aarch64-unknown-linux-gnu" ;;
  *)       echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

URL="https://github.com/InioX/matugen/releases/download/${MATUGEN_VERSION}/${BINARY}"

curl -fsSL "$URL" -o /usr/local/bin/matugen
chmod +x /usr/local/bin/matugen
