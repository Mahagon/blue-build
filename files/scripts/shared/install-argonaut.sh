#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=darksworm/argonaut
ARGONAUT_VERSION="2.14.1"

echo "Installing argonaut ${ARGONAUT_VERSION}..."
curl -fsSL "https://github.com/darksworm/argonaut/releases/download/v${ARGONAUT_VERSION}/argonaut-${ARGONAUT_VERSION}-linux-amd64.tar.gz" \
  -o /tmp/argonaut.tar.gz
echo "Downloaded $(stat -c%s /tmp/argonaut.tar.gz) bytes"
echo "Archive contents:"
tar -tzf /tmp/argonaut.tar.gz
tar xzf /tmp/argonaut.tar.gz -C /tmp argonaut
mv /tmp/argonaut /usr/bin/argonaut
chmod +x /usr/bin/argonaut
rm -f /tmp/argonaut.tar.gz
ls -la /usr/bin/argonaut
