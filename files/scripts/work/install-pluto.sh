#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=FairwindsOps/pluto
PLUTO_VERSION="5.23.5"

echo "Installing pluto ${PLUTO_VERSION}..."
curl -fsSL "https://github.com/FairwindsOps/pluto/releases/download/v${PLUTO_VERSION}/pluto_${PLUTO_VERSION}_linux_amd64.tar.gz" \
  -o /tmp/pluto.tar.gz
curl -fsSL "https://github.com/FairwindsOps/pluto/releases/download/v${PLUTO_VERSION}/checksums.txt" \
  -o /tmp/pluto-checksums.txt
echo "$(grep "pluto_${PLUTO_VERSION}_linux_amd64.tar.gz" /tmp/pluto-checksums.txt | awk '{print $1}')  /tmp/pluto.tar.gz" \
  | sha256sum --check
tar xzf /tmp/pluto.tar.gz -C /usr/bin pluto
chmod +x /usr/bin/pluto
rm -f /tmp/pluto.tar.gz /tmp/pluto-checksums.txt
