#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=tangency-labs/solidcraft
SOLIDCRAFT_VERSION="0.23.0"

echo "Installing SolidCraft ${SOLIDCRAFT_VERSION}..."
SOLIDCRAFT_RPM="solidcraft-${SOLIDCRAFT_VERSION}-linux-x86_64.rpm"
curl -fsSL "https://github.com/tangency-labs/solidcraft/releases/download/v${SOLIDCRAFT_VERSION}/${SOLIDCRAFT_RPM}" \
  -o "/tmp/${SOLIDCRAFT_RPM}"
curl -fsSL "https://github.com/tangency-labs/solidcraft/releases/download/v${SOLIDCRAFT_VERSION}/SHA256SUMS.txt" \
  -o /tmp/solidcraft-SHA256SUMS.txt
(cd /tmp && grep "  ${SOLIDCRAFT_RPM}\$" solidcraft-SHA256SUMS.txt | sha256sum --check)
mkdir -p /tmp/solidcraft
rpm2cpio "/tmp/${SOLIDCRAFT_RPM}" | cpio -idm -D /tmp/solidcraft
cp -r /tmp/solidcraft/usr/. /usr/
rm -rf "/tmp/${SOLIDCRAFT_RPM}" /tmp/solidcraft-SHA256SUMS.txt /tmp/solidcraft
