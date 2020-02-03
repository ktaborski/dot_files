#!/usr/bin/env bash
my_dir=$(dirname $(realpath $0))
find $my_dir \( -name ".*" -not -name '.git' \) -type f -exec ln -svf {} ~/ \;
