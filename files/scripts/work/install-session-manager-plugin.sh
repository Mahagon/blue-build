#!/usr/bin/env bash
set -euxo pipefail

echo "Installing session-manager-plugin..."
curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" \
  -o /tmp/session-manager-plugin.rpm
rpm2cpio /tmp/session-manager-plugin.rpm | cpio -idm -D /tmp/session-manager-plugin
mv /tmp/session-manager-plugin/usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/bin/
chmod +x /usr/bin/session-manager-plugin
rm -rf /tmp/session-manager-plugin.rpm /tmp/session-manager-plugin
