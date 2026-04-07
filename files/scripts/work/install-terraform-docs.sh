#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=terraform-docs/terraform-docs
TERRAFORM_DOCS_VERSION="0.22.0"

echo "Installing terraform-docs ${TERRAFORM_DOCS_VERSION}..."
curl -fsSL "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz" \
  -o /tmp/terraform-docs.tar.gz
curl -fsSL "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}.sha256sum" \
  -o /tmp/terraform-docs-checksums.txt
echo "$(grep "linux-amd64.tar.gz" /tmp/terraform-docs-checksums.txt | awk '{print $1}')  /tmp/terraform-docs.tar.gz" \
  | sha256sum --check
tar -xzf /tmp/terraform-docs.tar.gz -C /usr/bin terraform-docs
chmod +x /usr/bin/terraform-docs
rm -f /tmp/terraform-docs.tar.gz /tmp/terraform-docs-checksums.txt
