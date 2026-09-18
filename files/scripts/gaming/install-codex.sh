#!/usr/bin/env bash
set -euxo pipefail

# renovate: datasource=npm depName=@openai/codex
CODEX_VERSION="0.155.0"

echo "Installing OpenAI Codex CLI ${CODEX_VERSION}..."
npm install -g --prefix /usr "@openai/codex@${CODEX_VERSION}"
/usr/bin/codex --version
