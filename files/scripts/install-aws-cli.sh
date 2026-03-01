#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-tags depName=aws/aws-cli
AWS_CLI_VERSION="2.27.31"

curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" \
  -o /tmp/awscli.zip
unzip -o /tmp/awscli.zip -d /tmp
/tmp/aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin
rm -rf /tmp/aws /tmp/awscli.zip
