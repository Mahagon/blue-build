#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=npm depName=@anthropic-ai/claude-code
CLAUDE_CODE_VERSION="2.1.63"

npm install -g --prefix /usr/local "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}"
