#!/usr/bin/env bash

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

tfawsplan() {
  local environment=${1:-predev}
  local folder=${2:-infrastructure/terraform/platform-engineering}
  export AWS_PROFILE="$environment"
  assume "$environment"
  # shellcheck disable=SC2046
  export $(gh variable list --repo "zvoove-org/platform-engineering" --env "$environment" --json name,value | jq -r '.[] | "\(.name)=\(.value)"')
  local tfvars_file="${folder}/${environment}.tfvars"
  if [[ -f "$tfvars_file" ]]; then
    terraform -chdir="${folder}" plan -var-file="$environment.tfvars" "${@:3}"
  else
    terraform -chdir="${folder}" plan "${@:3}"
  fi
}

tfawsapply() {
  local environment=${1:-predev}
  local folder=${2:-infrastructure/terraform/platform-engineering}
  export AWS_PROFILE="$environment"
  assume "$environment"
  # shellcheck disable=SC2046
  export $(gh variable list --repo "zvoove-org/platform-engineering" --env "$environment" --json name,value | jq -r '.[] | "\(.name)=\(.value)"')
  local tfvars_file="${folder}/${environment}.tfvars"
  if [[ -f "$tfvars_file" ]]; then
    terraform -chdir="${folder}" apply -var-file="$environment.tfvars" "${@:3}"
  else
    terraform -chdir="${folder}" apply "${@:3}"
  fi
}

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
  export ARM_CLIENT_ID=$clientid
  export ARM_CLIENT_SECRET=$clientsecret
  export ARM_TENANT_ID=$tenantid
  export ARM_SUBSCRIPTION_ID=$subscriptionid
  az login --service-principal -u "$clientid" -p="$clientsecret" --tenant "$tenantid"
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
  export ARM_CLIENT_ID=$clientid
  export ARM_CLIENT_SECRET=$clientsecret
  export ARM_TENANT_ID=$tenantid
  export ARM_SUBSCRIPTION_ID=$subscriptionid
  az login --service-principal -u "$clientid" -p="$clientsecret" --tenant "$tenantid"
  az account set --subscription "zvoove-$environment"
  terraform -chdir="${folder}" init \
    -backend-config="storage_account_name=${storageaccount}" \
    -backend-config="resource_group_name=${resourcegroup}" \
    -reconfigure -upgrade
  terraform -chdir="${folder}" apply -var-file="$environment.tfvars" -parallelism=20 "${@:2}"
}

if [[ -n "${BASH_VERSION:-}" ]]; then
  _tf_complete_environment() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    mapfile -t COMPREPLY < <(compgen -W "predev dev staging prod" -- "$cur")
  }
  complete -F _tf_complete_environment tfaws tfawsplan tfawsapply tf tfavd tfbootstrap tfbootstrapapply
fi
