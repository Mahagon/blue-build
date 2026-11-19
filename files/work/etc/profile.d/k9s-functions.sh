#!/usr/bin/env bash

k9saws() {
  local environment=${1:-predev}
  (
    if [[ $environment != dev && $environment != predev ]]; then
      trap 'cleanup_k8s_aws_credentials "$environment"' EXIT
    fi
    get_k8s_aws_credentials "$environment" || exit 1
    EDITOR="code --wait" /usr/bin/k9s --context "zvoove-$environment-cluster" "${@:2}"
  )
}

if [[ -n "${BASH_VERSION:-}" ]]; then
  complete -F _zvoove_environments k9saws
fi
