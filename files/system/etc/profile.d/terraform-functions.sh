#!/usr/bin/env bash

_gh_export_vars() {
  local environment=$1
  while IFS= read -r line; do
    export "$line"
  done < <(gh variable list --repo "zvoove-org/platform-engineering" --env "$environment" --json name,value | jq -r '.[] | "\(.name)=\(.value)"')
}

_tfaws_run() {
  local verb=$1 environment=${2:-predev} folder=${3:-infrastructure/terraform/platform-engineering}
  export AWS_PROFILE="$environment"
  assume "$environment"
  _gh_export_vars "$environment"
  local tfvars_file="${folder}/${environment}.tfvars"
  if [[ -f "$tfvars_file" ]]; then
    terraform -chdir="${folder}" "$verb" -var-file="$environment.tfvars" "${@:4}"
  else
    terraform -chdir="${folder}" "$verb" "${@:4}"
  fi
}

tfaws() {
  local environment=${1:-predev}
  local folder=${2:-infrastructure/terraform/platform-engineering}
  export AWS_PROFILE="$environment"
  assume "$environment"
  terraform -chdir="${folder}" init -backend-config="./backend/${environment}.hcl" -upgrade -reconfigure
  local TERRAFORM_OUTPUTS
  TERRAFORM_OUTPUTS=$(terraform -chdir="${folder}" output -json)
  export TERRAFORM_OUTPUTS
}

tfawsplan()  { _tfaws_run plan  "$@"; }
tfawsapply() { _tfaws_run apply "$@"; }

tf() {
  local environment=${1:-predev}
  local folder=${2:-terraform/saas-infrastructure/}
  local storageaccount=${3:-$(yq -r .terraformStateStorageAccount "pipelines/saas-infrastructure/environment/${environment}.yaml")}
  local resourcegroup=${4:-$(yq -r .terraformStateResourceGroup "pipelines/saas-infrastructure/environment/${environment}.yaml")}
  (az aks list || az login) &> /dev/null
  az account set --subscription "zvoove-$environment"
  terraform -chdir="${folder}" init \
    -backend-config="storage_account_name=${storageaccount}" \
    -backend-config="resource_group_name=${resourcegroup}" \
    -reconfigure -upgrade "${@:5}"
}

tfavd() {
  local environment=${1:-predev}
  local folder=${2:-terraform/avd/}
  local storageaccount=${3:-$(yq -r .terraformStateStorageAccount "pipelines/avd/environment/${environment}.yaml")}
  local resourcegroup=${4:-$(yq -r .terraformStateResourceGroup "pipelines/avd/environment/${environment}.yaml")}
  local subscriptionid=${5:-$(yq -r .subscriptionId "pipelines/avd/environment/${environment}.yaml")}
  (az aks list || az login) &> /dev/null
  az account set --subscription "${subscriptionid}"
  terraform -chdir="${folder}" init \
    -backend-config="storage_account_name=${storageaccount}" \
    -backend-config="resource_group_name=${resourcegroup}" \
    -reconfigure -upgrade "${@:5}"
}

_tfbootstrap_login() {
  local clientid=$1 clientsecret=$2 tenantid=$3
  export ARM_CLIENT_ID="$clientid"
  export ARM_CLIENT_SECRET="$clientsecret"
  export ARM_TENANT_ID="$tenantid"
  # Pass secret via env var prefix to avoid exposure in process args
  AZURE_CLIENT_SECRET="$clientsecret" \
    az login --service-principal --username "$clientid" --tenant "$tenantid"
}

tfbootstrap() {
  local environment=${1:-predev}
  local folder=${2:-terraform/bootstrap/}
  local storageaccount=${3:-$(yq -r .terraformStateStorageAccount "pipelines/bootstrap/environment/${environment}.yaml")}
  local resourcegroup=${4:-$(yq -r .terraformStateResourceGroup "pipelines/bootstrap/environment/${environment}.yaml")}
  local clientid=${5:-$(yq -r .clientId "pipelines/bootstrap/environment/${environment}.yaml")}
  local tenantid=${6:-$(yq -r .tenantId "pipelines/bootstrap/environment/${environment}.yaml")}
  local subscriptionid=${7:-$(yq -r .subscriptionId "pipelines/bootstrap/environment/${environment}.yaml")}
  local clientsecret
  clientsecret=$(gopass show "zvoove-saas/azure/${environment}/bootstrap-pipeline-service-principal")
  export ARM_SUBSCRIPTION_ID="$subscriptionid"
  _tfbootstrap_login "$clientid" "$clientsecret" "$tenantid"
  az account set --subscription "zvoove-$environment"
  terraform -chdir="${folder}" init \
    -backend-config="storage_account_name=${storageaccount}" \
    -backend-config="resource_group_name=${resourcegroup}" \
    -reconfigure -upgrade "${@:5}"
}

tfbootstrapapply() {
  local environment=${1:-predev}
  local folder="terraform/bootstrap/"
  local storageaccount
  storageaccount=$(yq -r .terraformStateStorageAccount "pipelines/bootstrap/environment/${environment}.yaml")
  local resourcegroup
  resourcegroup=$(yq -r .terraformStateResourceGroup "pipelines/bootstrap/environment/${environment}.yaml")
  local clientid
  clientid=$(yq -r .clientId "pipelines/bootstrap/environment/${environment}.yaml")
  local tenantid
  tenantid=$(yq -r .tenantId "pipelines/bootstrap/environment/${environment}.yaml")
  local subscriptionid
  subscriptionid=$(yq -r .subscriptionId "pipelines/bootstrap/environment/${environment}.yaml")
  local clientsecret
  clientsecret=$(gopass show "zvoove-saas/azure/${environment}/bootstrap-pipeline-service-principal")
  export ARM_SUBSCRIPTION_ID="$subscriptionid"
  _tfbootstrap_login "$clientid" "$clientsecret" "$tenantid"
  az account set --subscription "zvoove-$environment"
  terraform -chdir="${folder}" init \
    -backend-config="storage_account_name=${storageaccount}" \
    -backend-config="resource_group_name=${resourcegroup}" \
    -reconfigure -upgrade
  terraform -chdir="${folder}" apply -var-file="$environment.tfvars" -parallelism=20 "${@:2}"
}

if [[ -n "${BASH_VERSION:-}" ]]; then
  complete -F _zvoove_environments tfaws tfawsplan tfawsapply tf tfavd tfbootstrap tfbootstrapapply
fi
