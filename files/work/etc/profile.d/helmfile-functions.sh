#!/usr/bin/env bash

export HELM_DIFF_COLOR=true

_helmfile_k8s_dir="infrastructure/k8s"

_helmfile_run() {
  local verb=$1 __subfolder=$2 __environment=${3:-predev}
  if [[ -z $__subfolder ]]; then
    echo "Usage: ha|hs|hd|ht <subfolder> [environment]"
    return 1
  fi
  if [[ ! -d "./${_helmfile_k8s_dir}" ]]; then
    echo "Error: ./${_helmfile_k8s_dir} not found (run from the platform-engineering repo root)" >&2
    return 1
  fi
  get_k8s_aws_credentials "$__environment" || return 1
  ENVIRONMENT="${__environment}" DEV_MACHINE=1 HELMFILE_VERB="$verb" "./${_helmfile_k8s_dir}/${__subfolder}/setup.sh"
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
    local subfolders
    subfolders=$(find "./${_helmfile_k8s_dir}" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' 2>/dev/null)
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
