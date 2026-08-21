#!/usr/bin/env bash

# Auto-activate a project .venv in Cursor/VS Code terminals.
# The Python Environments "command" activation times out in Cursor's bash
# integrated terminal (shell execution of `source .../activate`).
if [[ "${TERM_PROGRAM:-}" == "vscode" && -z "${VIRTUAL_ENV:-}" ]]; then
	if [[ -f .venv/bin/activate ]]; then
		# shellcheck disable=SC1091
		source .venv/bin/activate
	elif [[ -n "${VSCODE_CWD:-}" && -f "${VSCODE_CWD}/.venv/bin/activate" ]]; then
		# shellcheck disable=SC1091
		source "${VSCODE_CWD}/.venv/bin/activate"
	fi
fi
