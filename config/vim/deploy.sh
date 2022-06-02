#!/bin/bash

echo "execute $0"

# スクリプトの絶対パス
ABS_DIR="$( cd "$( dirname "$0" )" && pwd -P)"

# 展開
# TODO nvimディレクトリにも対応させる
DIR=$HOME/.config/vim
if [[ ! -d $DIR ]]; then
  echo "make directory '$DIR'"
  mkdir -p $DIR
fi
echo "deploy start"
for file in `find $ABS_DIR -type f`; do
  if [[ ! $file =~ \/deploy\.sh$ ]]; then
    dirpath=$DIR`dirname ${file#*$ABS_DIR}`
    if [[ ! -d $dirpath ]]; then
      echo "make directory '$dirpath'"
      mkdir -p $dirpath
    fi
    echo "[deploy] link $file to $dirpath"
    ln -fs $file $dirpath
  fi
done
