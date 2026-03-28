#!/usr/bin/env bash

gfixup() {
  local __commit_hash=${1}
  if [[ -z $__commit_hash ]]; then
    echo "missing commit hash as first parameter"
    return 1
  fi
  git commit --fixup "${__commit_hash}"
  git rebase --autosquash --interactive "${__commit_hash}~1"
}

gmerge() {
  local __branch=${1}
  if [[ -z $__branch ]]; then
    echo "missing branch name as first parameter"
    return 1
  fi
  git checkout main
  git fetch
  git pull
  git merge --ff-only "${__branch}"
  read -r -p "Do you want to push the changes? (y/n): " REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git pull -f
    git push
  fi
}

gr() {
  local __branch=${1:-origin/main}
  git fetch
  git rebase "${@:2}" "${__branch}"
}

gc() {
  local __message=${1}
  if [[ -z $__message ]]; then
    echo "missing commit message as first parameter"
    return 1
  fi
  git commit --signoff "${@:2}" --message "${__message}"
}

alias gca='git commit --signoff --amend'

gu() {
  local __amount=${1:-1}
  if ! [[ "$__amount" =~ ^[0-9]+$ ]]; then
    echo "Usage: gu [number_of_commits]"
    return 1
  fi
  git reset "${@:2}" --soft "HEAD~${__amount}"
}

alias gaa="git add ."
alias gau="git add -u"

grelease() {
  local kind="${1}"
  local name="${2}"
  local version="${3}"

  if [[ -z $kind || -z $name || -z $version ]]; then
    echo "Usage: grelease [image|chart] <name> <version>"
    return 1
  fi

  if [[ $kind != "image" && $kind != "chart" ]]; then
    echo "Error: kind must be 'image' or 'chart'"
    return 1
  fi

  local tag="release/${kind}/${name}/${version}"

  if git rev-parse "$tag" &>/dev/null; then
    read -r -p "Tag '$tag' already exists. Force overwrite? (y/n): " REPLY
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      git tag -a -f "$tag" -m "Release ${name} version ${version}"
      git push origin "refs/tags/${tag}" --force
    else
      echo "Aborted."
      return 1
    fi
  else
    git tag -a "$tag" -m "Release ${name} version ${version}"
    git push origin "refs/tags/${tag}"
  fi
}

if [[ -n "${BASH_VERSION:-}" ]]; then
  _git_branches() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local branches
    branches=$(git branch --sort=-committerdate 2>/dev/null | sed 's/^[* ]*//')
    mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
  }
  complete -F _git_branches gmerge

  _grelease() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local kind="${COMP_WORDS[1]}"

    case $COMP_CWORD in
      1)
        mapfile -t COMPREPLY < <(compgen -W "image chart" -- "$cur")
        ;;
      2)
        local base_dir
        if [[ $kind == "image" ]]; then
          base_dir="infrastructure/images"
        elif [[ $kind == "chart" ]]; then
          base_dir="infrastructure/charts"
        fi
        if [[ -n $base_dir && -d $base_dir ]]; then
          local names
          names=$(find "$base_dir" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' 2>/dev/null)
          mapfile -t COMPREPLY < <(compgen -W "$names" -- "$cur")
        fi
        ;;
    esac
  }
  complete -F _grelease grelease
fi
