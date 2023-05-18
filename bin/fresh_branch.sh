#!/usr/bin/env bash

git co "$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')"
git pull
git co -b $1