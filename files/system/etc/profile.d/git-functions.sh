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
  local __branch=${1:-origin/master}
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
  git reset "${@:2}" --soft "HEAD~${__amount}"
}

alias gaa="git add ."
alias gau="git add -u"

if [[ -n "${BASH_VERSION:-}" ]]; then
  _git_branches() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local branches
    branches=$(git branch --sort=-committerdate 2>/dev/null | sed 's/^[* ]*//')
    mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
  }
  complete -F _git_branches gmerge
fi
