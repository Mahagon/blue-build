#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=gopasspw/gopass
GOPASS_VERSION="1.16.1"

echo "Installing gopass ${GOPASS_VERSION}..."
curl -fsSL "https://github.com/gopasspw/gopass/releases/download/v${GOPASS_VERSION}/gopass-${GOPASS_VERSION}-linux-amd64.tar.gz" \
  -o /tmp/gopass.tar.gz
curl -fsSL "https://github.com/gopasspw/gopass/releases/download/v${GOPASS_VERSION}/gopass_${GOPASS_VERSION}_SHA256SUMS" \
  -o /tmp/gopass-checksums.txt
echo "$(grep "gopass-${GOPASS_VERSION}-linux-amd64.tar.gz" /tmp/gopass-checksums.txt | awk '{print $1}')  /tmp/gopass.tar.gz" \
  | sha256sum --check
tar xzf /tmp/gopass.tar.gz -C /usr/bin gopass
chmod +x /usr/bin/gopass
rm -f /tmp/gopass.tar.gz /tmp/gopass-checksums.txt
