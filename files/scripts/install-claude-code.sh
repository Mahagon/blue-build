#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=npm depName=@anthropic-ai/claude-code
CLAUDE_CODE_VERSION="1.0.128"

npm install -g "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}"
