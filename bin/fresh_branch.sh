#!/usr/bin/env bash
set -e
if [[ $2 == "stash" ]]; then
  git stash
fi
default_branch="$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')"
git co "${default_branch}"
git pull
git co -b $1 || (git co $1 && git rebase "${default_branch}")

if [[ $2 == "stash" ]]; then
  git stash apply
fi