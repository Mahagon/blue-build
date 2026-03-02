#!/usr/bin/env bash

k9saws() {
  local environment=${1:-predev}
  if [[ $environment != dev && $environment != predev ]]; then
    _K9SAWS_CLEANUP_ENV="$environment"
    trap 'cleanup_k8s_aws_credentials "$_K9SAWS_CLEANUP_ENV"' EXIT
  fi
  get_k8s_aws_credentials "$environment"
  EDITOR="code --wait" /usr/bin/k9s --context "zvoove-$environment-cluster" "${@:2}"
}

k9saz() {
  local environment=${1:-predev}
  if [[ $environment != dev && $environment != predev ]]; then
    _K9SAZ_CLEANUP_ENV="$environment"
    trap 'cleanup_k8s_az_credentials "$_K9SAZ_CLEANUP_ENV"' EXIT
  fi
  # shellcheck disable=SC2034
  local resourcegroup
  resourcegroup=$(yq -r .terraformStateResourceGroup "$HOME/Documents/src/zvoove-SaaS/pipelines/saas-infrastructure/environment/${environment}.yaml")
  (az aks list || az login) &> /dev/null
  get_k8s_az_credentials "$environment"
  EDITOR="code --wait" /usr/bin/k9s "${@:2}"
}

if [[ -n "${BASH_VERSION:-}" ]]; then
  _k9s_complete_environment() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    mapfile -t COMPREPLY < <(compgen -W "predev dev staging prod" -- "$cur")
  }
  complete -F _k9s_complete_environment k9saws
  complete -F _k9s_complete_environment k9saz
fi
