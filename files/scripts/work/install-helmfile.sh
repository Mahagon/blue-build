#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=helmfile/helmfile
HELMFILE_VERSION="1.4.2"

echo "Installing helmfile ${HELMFILE_VERSION}..."
curl -fsSL "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz" \
  -o /tmp/helmfile.tar.gz
echo "Downloaded $(stat -c%s /tmp/helmfile.tar.gz) bytes"
echo "Archive contents:"
tar -tzf /tmp/helmfile.tar.gz
tar xzf /tmp/helmfile.tar.gz -C /usr/bin helmfile
rm -f /tmp/helmfile.tar.gz
chmod +x /usr/bin/helmfile
ls -la /usr/bin/helmfile
