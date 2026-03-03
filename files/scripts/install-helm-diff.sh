#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=databus23/helm-diff
HELM_DIFF_VERSION="3.15.2"

echo "Installing helm-diff ${HELM_DIFF_VERSION}..."
mkdir -p /usr/lib/helm/plugins/helm-diff
curl -fsSL "https://github.com/databus23/helm-diff/releases/download/v${HELM_DIFF_VERSION}/helm-diff-linux-amd64.tgz" \
  | tar xz -C /usr/lib/helm/plugins/helm-diff --strip-components=1
chmod +x /usr/lib/helm/plugins/helm-diff/bin/diff
