#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=helmfile/helmfile
HELMFILE_VERSION="1.4.4"

echo "Installing helmfile ${HELMFILE_VERSION}..."
curl -fsSL "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz" \
  -o /tmp/helmfile.tar.gz
curl -fsSL "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_checksums.txt" \
  -o /tmp/helmfile-checksums.txt
echo "$(grep "helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz" /tmp/helmfile-checksums.txt | awk '{print $1}')  /tmp/helmfile.tar.gz" \
  | sha256sum --check
tar xzf /tmp/helmfile.tar.gz -C /usr/bin helmfile
chmod +x /usr/bin/helmfile
rm -f /tmp/helmfile.tar.gz /tmp/helmfile-checksums.txt
