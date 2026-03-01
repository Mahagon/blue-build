#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=npm depName=@anthropic-ai/claude-code
CLAUDE_CODE_VERSION="2.1.63"

export CLAUDEINSTALL=/tmp/claude-install
home="$CLAUDEINSTALL"
mkdir -p "$CLAUDEINSTALL"
curl -fsSL https://claude.ai/install.sh | bash -s "${CLAUDE_CODE_VERSION}"
cp "$CLAUDEINSTALL/.claude/local/claude" /usr/local/bin/claude
chmod +x /usr/local/bin/claude
rm -rf "$CLAUDEINSTALL"
export HOME="$home"
