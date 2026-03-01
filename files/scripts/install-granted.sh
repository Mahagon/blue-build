#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=fwdcloudsec/granted
GRANTED_VERSION="0.36.2"

curl -fsSL "https://releases.commonfate.io/granted/v${GRANTED_VERSION}/granted_${GRANTED_VERSION}_linux_x86_64.tar.gz" \
  -o /tmp/granted.tar.gz
tar xzf /tmp/granted.tar.gz -C /tmp granted assumego assume assume.fish
mv /tmp/granted /usr/local/bin/granted
mv /tmp/assumego /usr/local/bin/assumego
mv /tmp/assume /usr/local/bin/assume
mv /tmp/assume.fish /usr/local/bin/assume.fish
chmod +x /usr/local/bin/granted /usr/local/bin/assumego /usr/local/bin/assume
rm -f /tmp/granted.tar.gz
