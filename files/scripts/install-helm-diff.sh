HELM_DIFF_VERSION="3.15.1"
mkdir -p /usr/lib/helm/plugins/helm-diff/bin
curl -fsSL "https://github.com/databus23/helm-diff/releases/download/v${HELM_DIFF_VERSION}/helm-diff-linux-amd64.tgz" \
  | tar xz -C /usr/lib/helm/plugins/helm-diff
