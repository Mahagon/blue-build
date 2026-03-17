#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=norwoodj/helm-docs
HELM_DOCS_VERSION="1.14.2"

echo "Installing helm-docs ${HELM_DOCS_VERSION}..."
curl -fsSL "https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION}_Linux_x86_64.tar.gz" \
  -o /tmp/helm-docs.tar.gz
tar -xzf /tmp/helm-docs.tar.gz -C /usr/bin helm-docs
chmod +x /usr/bin/helm-docs
rm -f /tmp/helm-docs.tar.gz
