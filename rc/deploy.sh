#!/bin/bash

script_file=$BASH_SOURCE
if [[ -z $script_file ]]; then
  log_error 'variable $BASH_SOURCE has not found.'
  exit 1
fi

log_info "execute $script_file"

# スクリプトの絶対パス
ABS_DIR="$( cd "$( dirname "$script_file" )" && pwd -P)"

# 展開
log_info "###### deploy start ######"
# ディレクトリ直下のファイルのみをホームディレクトリに展開
for f in `find $ABS_DIR -maxdepth 1 -type f`; do
  if [[ ! $f =~ \/deploy\.sh$ ]]; then
    log_info "link $f to $HOME"
    ln -fs $f $HOME
  fi
done
log_info "##### deploy end #####"

log_info "complete $script_file"
echo ""
