#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=bitnami-labs/sealed-secrets
KUBESEAL_VERSION="0.36.1"

echo "Installing kubeseal ${KUBESEAL_VERSION}..."
curl -fsSL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz" \
  -o /tmp/kubeseal.tar.gz
echo "Downloaded $(stat -c%s /tmp/kubeseal.tar.gz) bytes"
echo "Archive contents:"
tar -tzf /tmp/kubeseal.tar.gz
tar xzf /tmp/kubeseal.tar.gz -C /usr/bin kubeseal
rm -f /tmp/kubeseal.tar.gz
chmod +x /usr/bin/kubeseal
ls -la /usr/bin/kubeseal
