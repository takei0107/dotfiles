#!/bin/bash

echo "execute $0"

# スクリプトの絶対パス
ABS_DIR="$( cd "$( dirname "$0" )" && pwd -P)"

# 展開
echo "deploy start"
# ディレクトリ直下のファイルのみをホームディレクトリに展開
for file in `find $ABS_DIR -maxdepth 1 -type f`; do
  if [[ ! $file =~ \/deploy\.sh$ ]]; then
    echo "[deploy] link $file to $HOME"
    ln -fs $file $HOME
  fi
done
