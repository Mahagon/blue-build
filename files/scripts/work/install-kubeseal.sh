#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=bitnami-labs/sealed-secrets
KUBESEAL_VERSION="0.36.3"

echo "Installing kubeseal ${KUBESEAL_VERSION}..."
curl -fsSL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz" \
  -o /tmp/kubeseal.tar.gz
curl -fsSL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/sealed-secrets_${KUBESEAL_VERSION}_checksums.txt" \
  -o /tmp/kubeseal-checksums.txt
echo "$(grep "kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz" /tmp/kubeseal-checksums.txt | awk '{print $1}')  /tmp/kubeseal.tar.gz" \
  | sha256sum --check
tar xzf /tmp/kubeseal.tar.gz -C /usr/bin kubeseal
chmod +x /usr/bin/kubeseal
rm -f /tmp/kubeseal.tar.gz /tmp/kubeseal-checksums.txt
