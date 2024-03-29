#!/usr/bin/env bash
my_dir=$(dirname $(realpath $0))
find $my_dir \( -name ".*" -not -name '.git' \) -type f -exec ln -svf {} ~/ \;

mkdir -p ~/bin
find $my_dir/bin -type f -exec ln -svf {} ~/bin \;

while IFS= read -r -d '' file
do
  file_rel="${file/$my_dir\/}"
  file_dir=$(dirname "${file_rel}")
  mkdir -p ~/"${file_dir}"
  ln -svf ${file} ~/"${file_dir}/"
done < <(find $my_dir/.config -type f -print0)

make -C ${my_dir}/retry install
make -C ${my_dir}/decode-secret install