#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=databus23/helm-diff
HELM_DIFF_VERSION="3.15.3"

echo "Installing helm-diff ${HELM_DIFF_VERSION}..."
mkdir -p /usr/lib/helm/plugins/helm-diff
curl -fsSL "https://github.com/databus23/helm-diff/releases/download/v${HELM_DIFF_VERSION}/helm-diff-linux-amd64.tgz" \
  -o /tmp/helm-diff.tgz
echo "Downloaded $(stat -c%s /tmp/helm-diff.tgz) bytes"
echo "Archive contents:"
tar -tzf /tmp/helm-diff.tgz
tar xzf /tmp/helm-diff.tgz -C /usr/lib/helm/plugins/helm-diff --strip-components=1
rm -f /tmp/helm-diff.tgz
chmod +x /usr/lib/helm/plugins/helm-diff/bin/diff
ls -la /usr/lib/helm/plugins/helm-diff/bin/diff
