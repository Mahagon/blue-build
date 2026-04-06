#!/usr/bin/env bash
set -euxo pipefail

# Fix sudoers drop-in permissions - git cannot track 0440 mode,
# so we enforce it at image build time.
# The file is laid down by the files module before this script runs
# in a real build, but may not exist during CI script testing.
SUDOERS_FILE="/etc/sudoers.d/vr-power-profile"

if [[ ! -f "$SUDOERS_FILE" ]]; then
    echo "SKIP: $SUDOERS_FILE not found (expected during CI testing)"
    exit 0
fi

chmod 0440 "$SUDOERS_FILE"

# Verify the file is accepted by sudo and has the correct permissions
visudo -cf "$SUDOERS_FILE"
stat -c "%a" "$SUDOERS_FILE" | grep -qx "440" \
    || { echo "ERROR: sudoers drop-in has wrong permissions" >&2; exit 1; }
