#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=terraform-linters/tflint
TFLINT_VERSION="0.61.0"

echo "Installing tflint ${TFLINT_VERSION}..."
curl -fsSL "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" \
  -o /tmp/tflint.zip
echo "Downloaded $(stat -c%s /tmp/tflint.zip) bytes"
unzip -p /tmp/tflint.zip tflint > /usr/bin/tflint
chmod +x /usr/bin/tflint
rm -f /tmp/tflint.zip
ls -la /usr/bin/tflint
