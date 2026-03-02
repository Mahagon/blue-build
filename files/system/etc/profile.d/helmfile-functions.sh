#!/usr/bin/env bash

export HELM_DIFF_COLOR=true

ha() {
  local parent_folder
  parent_folder="$(basename "$(pwd)")"
  local __subfolder=${1}
  local __environment=${2:-predev}
  if [[ "$parent_folder" == "zvoove-SaaS" ]]; then
    get_k8s_az_credentials "$__environment"
    ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="apply --context 3" "./k8s/${__subfolder}/setup.sh"
  elif [[ "$parent_folder" == "platform-engineering" ]]; then
    get_k8s_aws_credentials "$__environment"
    ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="apply --context 3" "./infrastructure/k8s/${__subfolder}/setup.sh"
  fi
}

hs() {
  local parent_folder
  parent_folder="$(basename "$(pwd)")"
  local __subfolder=${1}
  local __environment=${2:-predev}
  if [[ "$parent_folder" == "zvoove-SaaS" ]]; then
    get_k8s_az_credentials "$__environment"
    ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="sync" "./k8s/${__subfolder}/setup.sh"
  elif [[ "$parent_folder" == "platform-engineering" ]]; then
    get_k8s_aws_credentials "$__environment"
    ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="sync" "./infrastructure/k8s/${__subfolder}/setup.sh"
  fi
}

hd() {
  local parent_folder
  parent_folder="$(basename "$(pwd)")"
  local __subfolder=${1}
  local __environment=${2:-predev}
  if [[ "$parent_folder" == "zvoove-SaaS" ]]; then
    get_k8s_az_credentials "$__environment"
    ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="diff --context 3" "./k8s/${__subfolder}/setup.sh"
  elif [[ "$parent_folder" == "platform-engineering" ]]; then
    get_k8s_aws_credentials "$__environment"
    ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="diff --context 3" "./infrastructure/k8s/${__subfolder}/setup.sh"
  fi
}

ht() {
  local parent_folder
  parent_folder="$(basename "$(pwd)")"
  local __subfolder=${1}
  local __environment=${2:-predev}
  if [[ "$parent_folder" == "zvoove-SaaS" ]]; then
    get_k8s_az_credentials "$__environment"
    ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="template" "./k8s/${__subfolder}/setup.sh"
  elif [[ "$parent_folder" == "platform-engineering" ]]; then
    get_k8s_aws_credentials "$__environment"
    ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="template" "./infrastructure/k8s/${__subfolder}/setup.sh"
  fi
}

hdestroy() {
  local parent_folder
  parent_folder="$(basename "$(pwd)")"
  local __subfolder=${1}
  local __environment=${2:-predev}
  if [[ "$parent_folder" == "zvoove-SaaS" ]]; then
    get_k8s_az_credentials "$__environment"
  elif [[ "$parent_folder" == "platform-engineering" ]]; then
    get_k8s_aws_credentials "$__environment"
  fi
  read -r -n 1 -p "Are you sure to destroy the ${__subfolder} deployment? [press y] " REPLY
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ "$parent_folder" == "zvoove-SaaS" ]]; then
      ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="destroy" "./k8s/${__subfolder}/setup.sh"
    elif [[ "$parent_folder" == "platform-engineering" ]]; then
      ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="destroy" "./infrastructure/k8s/${__subfolder}/setup.sh"
    fi
  else
    echo abort
  fi
}

if [[ -n "${BASH_VERSION:-}" ]]; then
  _helmfile_subfolders() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local parent_folder
    parent_folder="$(basename "$(pwd)")"
    local subfolders=""
    if [[ "$parent_folder" == "zvoove-SaaS" ]]; then
      subfolders=$(find ./k8s -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null)
    elif [[ "$parent_folder" == "platform-engineering" ]]; then
      subfolders=$(find ./infrastructure/k8s -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null)
    fi
    mapfile -t COMPREPLY < <(compgen -W "$subfolders" -- "$cur")
  }

  _helmfile_environments() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    mapfile -t COMPREPLY < <(compgen -W "predev dev staging prod" -- "$cur")
  }

  _helmfile_complete() {
    case $COMP_CWORD in
      1) _helmfile_subfolders ;;
      2) _helmfile_environments ;;
    esac
  }

  complete -F _helmfile_complete ha hs hd ht hdestroy
fi
