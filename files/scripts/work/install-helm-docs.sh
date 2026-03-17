#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=norwoodj/helm-docs
HELM_DOCS_VERSION="1.14.2"

echo "Installing helm-docs ${HELM_DOCS_VERSION}..."
curl -fsSL "https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION}_Linux_x86_64.tar.gz" \
  | tar xz -C /usr/bin helm-docs
chmod +x /usr/bin/helm-docs
