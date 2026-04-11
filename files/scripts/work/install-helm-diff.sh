#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=databus23/helm-diff
HELM_DIFF_VERSION="3.15.5"

echo "Installing helm-diff ${HELM_DIFF_VERSION}..."
mkdir -p /usr/lib/helm/plugins/helm-diff
curl -fsSL "https://github.com/databus23/helm-diff/releases/download/v${HELM_DIFF_VERSION}/helm-diff-linux-amd64.tgz" \
  -o /tmp/helm-diff.tgz
curl -fsSL "https://github.com/databus23/helm-diff/releases/download/v${HELM_DIFF_VERSION}/helm-diff_${HELM_DIFF_VERSION}_checksums.txt" \
  -o /tmp/helm-diff-checksums.txt
echo "$(grep "helm-diff-linux-amd64.tgz" /tmp/helm-diff-checksums.txt | awk '{print $1}')  /tmp/helm-diff.tgz" \
  | sha256sum --check
tar xzf /tmp/helm-diff.tgz -C /usr/lib/helm/plugins/helm-diff --strip-components=1
chmod +x /usr/lib/helm/plugins/helm-diff/bin/diff
rm -f /tmp/helm-diff.tgz /tmp/helm-diff-checksums.txt
