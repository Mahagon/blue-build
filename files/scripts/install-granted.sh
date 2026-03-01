#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=fwdcloudsec/granted
GRANTED_VERSION="0.38.0"

curl -fsSL "https://releases.commonfate.io/granted/v${GRANTED_VERSION}/granted_${GRANTED_VERSION}_linux_x86_64.tar.gz" \
  -o /tmp/granted.tar.gz
tar xzf /tmp/granted.tar.gz -C /tmp granted assumego assume assume.fish
mv /tmp/granted /usr/bin/granted
mv /tmp/assumego /usr/bin/assumego
mv /tmp/assume /usr/bin/assume
mv /tmp/assume.fish /usr/bin/assume.fish
chmod +x /usr/bin/granted /usr/bin/assumego /usr/bin/assume
rm -f /tmp/granted.tar.gz
