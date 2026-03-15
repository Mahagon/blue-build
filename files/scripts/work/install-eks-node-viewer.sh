#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=awslabs/eks-node-viewer
EKS_NODE_VIEWER_VERSION="0.7.4"

echo "Installing eks-node-viewer ${EKS_NODE_VIEWER_VERSION}..."
curl -fsSL "https://github.com/awslabs/eks-node-viewer/releases/download/v${EKS_NODE_VIEWER_VERSION}/eks-node-viewer_Linux_x86_64" \
  -o /usr/bin/eks-node-viewer
chmod +x /usr/bin/eks-node-viewer
