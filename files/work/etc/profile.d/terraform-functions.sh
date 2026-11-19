#!/usr/bin/env bash

_tfaws_default_folder="infrastructure/terraform/platform-engineering"

_aws_login() {
  local environment=$1
  _validate_environment "$environment" || return 1
  export AWS_PROFILE="$environment"
  assume "$environment"
}

_gh_export_vars() {
  local environment=$1
  local name value
  while IFS='=' read -r name value; do
    [[ "$name" =~ ^[A-Z_][A-Z0-9_]*$ ]] || { echo "Warning: skipping invalid variable name '$name'" >&2; continue; }
    export "$name=$value"
  done < <(gh variable list --repo "zvoove-org/platform-engineering" --env "$environment" --json name,value | jq -r '.[] | "\(.name)=\(.value)"')
}

_tfaws_run() {
  local verb=$1 environment=${2:-predev} folder=${3:-$_tfaws_default_folder}
  _aws_login "$environment" || return 1
  _gh_export_vars "$environment"
  if [[ -f "${folder}/${environment}.tfvars" ]]; then
    terraform -chdir="${folder}" "$verb" -var-file="$environment.tfvars" "${@:4}"
  else
    terraform -chdir="${folder}" "$verb" "${@:4}"
  fi
}

tfaws() {
  local environment=${1:-predev} folder=${2:-$_tfaws_default_folder}
  _aws_login "$environment" || return 1
  terraform -chdir="${folder}" init -backend-config="./backend/${environment}.hcl" -upgrade -reconfigure || return 1
  local TERRAFORM_OUTPUTS
  TERRAFORM_OUTPUTS=$(terraform -chdir="${folder}" output -json)
  export TERRAFORM_OUTPUTS
}

tfawsplan()  { _tfaws_run plan  "$@"; }
tfawsapply() { _tfaws_run apply "$@"; }

if [[ -n "${BASH_VERSION:-}" ]]; then
  complete -F _zvoove_environments tfaws tfawsplan tfawsapply
fi
