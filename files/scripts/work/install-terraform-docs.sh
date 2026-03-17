#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=terraform-docs/terraform-docs
TERRAFORM_DOCS_VERSION="0.21.0"

echo "Installing terraform-docs ${TERRAFORM_DOCS_VERSION}..."
curl -fsSL "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz" \
  -o /tmp/terraform-docs.tar.gz
echo "Downloaded $(stat -c%s /tmp/terraform-docs.tar.gz) bytes"
echo "Archive contents:"
tar -tzf /tmp/terraform-docs.tar.gz
tar -xzf /tmp/terraform-docs.tar.gz -C /usr/bin terraform-docs
ls -la /usr/bin/terraform-docs
rm -f /tmp/terraform-docs.tar.gz
