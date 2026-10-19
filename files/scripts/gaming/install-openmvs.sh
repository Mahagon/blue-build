#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=github-releases depName=cdcseacave/openMVS
OPENMVS_VERSION="2.4.0"

echo "Installing OpenMVS ${OPENMVS_VERSION}..."
curl -fsSL "https://github.com/cdcseacave/openMVS/releases/download/v${OPENMVS_VERSION}/OpenMVS_Ubuntu_x64.zip" \
  -o /tmp/openmvs.zip
# Upstream publishes no checksums file; use the asset digest GitHub records for the release.
curl -fsSL "https://api.github.com/repos/cdcseacave/openMVS/releases/tags/v${OPENMVS_VERSION}" \
  -o /tmp/openmvs-release.json
OPENMVS_SHA256="$(python3 -c 'import json, sys
assets = json.load(open(sys.argv[1]))["assets"]
print(next(a["digest"] for a in assets if a["name"] == "OpenMVS_Ubuntu_x64.zip").removeprefix("sha256:"))' \
  /tmp/openmvs-release.json)"
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
rm -f /tmp/openmvs.zip /tmp/openmvs-release.json
