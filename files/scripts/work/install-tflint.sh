#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=terraform-linters/tflint
TFLINT_VERSION="0.62.0"

echo "Installing tflint ${TFLINT_VERSION}..."
curl -fsSL "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" \
  -o /tmp/tflint.zip
curl -fsSL "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/checksums.txt" \
  -o /tmp/tflint-checksums.txt
echo "$(grep "tflint_linux_amd64.zip" /tmp/tflint-checksums.txt | awk '{print $1}')  /tmp/tflint.zip" \
  | sha256sum --check
unzip -p /tmp/tflint.zip tflint > /tmp/tflint
mv /tmp/tflint /usr/bin/tflint
chmod +x /usr/bin/tflint
rm -f /tmp/tflint.zip /tmp/tflint-checksums.txt
