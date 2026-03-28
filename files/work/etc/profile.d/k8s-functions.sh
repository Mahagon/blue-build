#!/usr/bin/env bash

_az_ensure_login() {
  az account show &>/dev/null || az login
}

get_k8s_az_credentials() {
  local environment=${1:-predev}
  _az_ensure_login
  az account set --subscription "zvoove-$environment"
  az aks get-credentials --resource-group "RGAZSAAS" --name "zvoove-saas-$environment" --overwrite-existing
  kubelogin convert-kubeconfig -l azurecli
  kubectl config use-context "zvoove-saas-$environment"
}

get_k8s_aws_credentials() {
  local environment=${1:-predev}
  assume "$environment"
  kubectl config use-context "zvoove-$environment-cluster"
}

cleanup_k8s_aws_credentials() {
  local environment=${1:-predev}
  kubectl config unset "users.zvoove-$environment-cluster" || true
}

cleanup_k8s_az_credentials() {
  local environment=${1:-predev}
  kubectl config unset "users.zvoove-saas-$environment" || true
  kubectl config unset "users.clusterUser_RGAZSAAS_zvoove-saas-$environment" || true
}

if [[ -n "${BASH_VERSION:-}" ]]; then
  _zvoove_environments() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    mapfile -t COMPREPLY < <(compgen -W "predev dev staging prod" -- "$cur")
  }
fi
