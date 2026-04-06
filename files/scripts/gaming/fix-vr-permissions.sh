#!/usr/bin/env bash
set -euxo pipefail

# Fix sudoers drop-in permissions — git cannot track 0440 mode,
# so we enforce it at image build time.
chmod 0440 /etc/sudoers.d/vr-power-profile

# Verify the file is accepted by sudo and has the correct permissions
visudo -cf /etc/sudoers.d/vr-power-profile
stat -c "%a" /etc/sudoers.d/vr-power-profile | grep -qx "440" \
    || { echo "ERROR: sudoers drop-in has wrong permissions" >&2; exit 1; }
