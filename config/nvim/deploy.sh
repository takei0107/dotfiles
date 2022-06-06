#!/bin/bash

script_name=$BASH_SOURCE
if [[ -z $script_name ]]; then
  log_error 'variable $BASH_SOURCE has not found.'
  exit 1
fi

log_info "execute $script_name"

# スクリプトの絶対パス
ABS_DIR="$( cd "$( dirname "$script_name" )" && pwd -P)"

# 展開
log_info "###### deploy start ######"
DIR=$HOME/.config/nvim
for f in `find $ABS_DIR -type f`; do
  if [[ ! $f =~ \/deploy\.sh$ ]]; then
    dirpath=$DIR`dirname ${f#*$ABS_DIR}`
    mkdir_if_not_exists $dirpath
    log_info "link $f to $dirpath"
    ln -fs $f $dirpath
  fi
done
log_info "##### deploy end #####"

log_info "complete $script_name"
echo ""
