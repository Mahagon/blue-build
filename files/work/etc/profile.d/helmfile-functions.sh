#!/usr/bin/env bash

export HELM_DIFF_COLOR=true

_helmfile_run() {
  local verb=$1 __subfolder=$2 __environment=${3:-predev}
  if [[ -z $__subfolder ]]; then
    echo "Usage: ha|hs|hd|ht <subfolder> [environment]"
    return 1
  fi
  local parent_folder
  parent_folder="$(basename "$(pwd)")"
  if [[ "$parent_folder" == "zvoove-SaaS" ]]; then
    get_k8s_az_credentials "$__environment"
    ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="$verb" "./k8s/${__subfolder}/setup.sh"
  elif [[ "$parent_folder" == "platform-engineering" ]]; then
    get_k8s_aws_credentials "$__environment"
    ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="$verb" "./infrastructure/k8s/${__subfolder}/setup.sh"
  fi
}

ha()       { _helmfile_run "apply --context 3" "$@"; }
hs()       { _helmfile_run "sync"              "$@"; }
hd()       { _helmfile_run "diff --context 3"  "$@"; }
ht()       { _helmfile_run "template"          "$@"; }

hdestroy() {
  local __subfolder=${1}
  local __environment=${2:-predev}
  if [[ -z $__subfolder ]]; then
    echo "Usage: hdestroy <subfolder> [environment]"
    return 1
  fi
  read -r -n 1 -p "Are you sure to destroy the ${__subfolder} deployment? [press y] " REPLY
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    _helmfile_run "destroy" "$__subfolder" "$__environment"
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
      subfolders=$(find ./k8s -maxdepth 1 -mindepth 1 -type d -printf '%f\n' 2>/dev/null)
    elif [[ "$parent_folder" == "platform-engineering" ]]; then
      subfolders=$(find ./infrastructure/k8s -maxdepth 1 -mindepth 1 -type d -printf '%f\n' 2>/dev/null)
    fi
    mapfile -t COMPREPLY < <(compgen -W "$subfolders" -- "$cur")
  }

  _helmfile_complete() {
    case $COMP_CWORD in
      1) _helmfile_subfolders ;;
      2) _zvoove_environments ;;
    esac
  }

  complete -F _helmfile_complete ha hs hd ht hdestroy
fi
