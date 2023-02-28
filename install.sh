#!/usr/bin/env bash
my_dir=$(dirname $(realpath $0))
find $my_dir \( -name ".*" -not -name '.git' \) -type f -exec ln -svf {} ~/ \;

find $my_dir/bin -type f -exec ln -svf {} ~/bin \;

while IFS= read -r -d '' file
do
  file_rel="${file/$my_dir\/}"
  file_dir=$(dirname "${file_rel}")
  mkdir -p "${file_dir}"
  ln -svf ${file} ~/"${file_dir}/"
done < <(find $my_dir/.config -type f -print0)

make -C retry install