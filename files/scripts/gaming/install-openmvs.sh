#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=cdcseacave/openMVS
OPENMVS_VERSION="2.4.0"

echo "Installing OpenMVS ${OPENMVS_VERSION}..."
curl -fsSL --retry 5 --retry-delay 5 "https://github.com/cdcseacave/openMVS/releases/download/v${OPENMVS_VERSION}/OpenMVS_Ubuntu_x64.zip" \
  -o /tmp/openmvs.zip
# Upstream publishes no checksums file; use the asset digest GitHub records for the release.
# Read it from the release page, not api.github.com: unauthenticated API calls
# from shared CI runners get rate-limited (HTTP 403).
curl -fsSL --retry 5 --retry-delay 5 "https://github.com/cdcseacave/openMVS/releases/expanded_assets/v${OPENMVS_VERSION}" \
  -o /tmp/openmvs-release.html
OPENMVS_SHA256="$(python3 -c 'import re, sys
html = open(sys.argv[1]).read()
print(re.search(r"clipboard-button-sha256:([0-9a-f]{64})\" aria-label=\"Copy to clipboard digest for OpenMVS_Ubuntu_x64\.zip\"", html)[1])' \
  /tmp/openmvs-release.html)"
echo "${OPENMVS_SHA256}  /tmp/openmvs.zip" | sha256sum --check
mkdir -p /usr/lib/openmvs
unzip -o -q /tmp/openmvs.zip -d /usr/lib/openmvs
rm -f /usr/lib/openmvs/Tests
chmod +x /usr/lib/openmvs/*
for tool in /usr/lib/openmvs/*; do
  name="$(basename "${tool}")"
  # "Viewer" is too generic for /usr/bin.
  [[ "${name}" == "Viewer" ]] && name="OpenMVSViewer"
  ln -sf "${tool}" "/usr/bin/${name}"
done
rm -f /tmp/openmvs.zip /tmp/openmvs-release.html
