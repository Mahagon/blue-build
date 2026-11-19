#!/usr/bin/env bash

_validate_environment() {
  local environment=$1
  case "$environment" in
    predev|dev|staging|prod) return 0 ;;
    *) echo "Error: unknown environment '$environment' (expected: predev, dev, staging, prod)" >&2; return 1 ;;
  esac
}

get_k8s_aws_credentials() {
  local environment=${1:-predev}
  _validate_environment "$environment" || return 1
  assume "$environment"
  kubectl config use-context "zvoove-$environment-cluster"
}

cleanup_k8s_aws_credentials() {
  local environment=${1:-predev}
  kubectl config unset "users.zvoove-$environment-cluster" || true
}

if [[ -n "${BASH_VERSION:-}" ]]; then
  _zvoove_environments() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    mapfile -t COMPREPLY < <(compgen -W "predev dev staging prod" -- "$cur")
  }
fi
