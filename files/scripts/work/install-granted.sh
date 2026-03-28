#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=fwdcloudsec/granted
GRANTED_VERSION="0.38.0"

echo "Installing granted ${GRANTED_VERSION}..."
curl -fsSL "https://github.com/fwdcloudsec/granted/releases/download/v${GRANTED_VERSION}/granted_${GRANTED_VERSION}_linux_x86_64.tar.gz" \
  -o /tmp/granted.tar.gz
curl -fsSL "https://github.com/fwdcloudsec/granted/releases/download/v${GRANTED_VERSION}/checksums.txt" \
  -o /tmp/granted-checksums.txt
echo "$(grep "granted_${GRANTED_VERSION}_linux_x86_64.tar.gz" /tmp/granted-checksums.txt | awk '{print $1}')  /tmp/granted.tar.gz" \
  | sha256sum --check
tar xzf /tmp/granted.tar.gz -C /tmp granted assumego assume assume.fish
mv /tmp/granted /usr/bin/granted
mv /tmp/assumego /usr/bin/assumego
mv /tmp/assume /usr/bin/assume
mv /tmp/assume.fish /usr/bin/assume.fish
chmod +x /usr/bin/granted /usr/bin/assumego /usr/bin/assume
rm -f /tmp/granted.tar.gz /tmp/granted-checksums.txt
