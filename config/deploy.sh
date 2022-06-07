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
DIR=$HOME/.config
# vim,nvimディレクトリは独自のdeploy.shあるので除外
# configディレクトリはスクリプトのあるディレクトリなので除外
for d in `find $ABS_DIR -maxdepth 1 -type d | grep -v -e '/\(vim\|nvim\|config\)$'`; do
  for f in `find $d -type f`; do
    if [[ ! $f =~ \/deploy\.sh$ ]]; then
      # tmux,xディレクトリのファイルはホームに展開
      if [[ $d =~ \/x$ ]] || [[ $d =~ \/tmux$ ]];then
        dirpath=$HOME
      else
        dirpath=$DIR`dirname ${f#*$ABS_DIR}`
      fi
      mkdir_if_not_exists $dirpath
      log_info "link $f to $dirpath"
      ln -fs $f $dirpath
    fi
  done
done
log_info "##### deploy end #####"
log_info "complete $script_name"
echo ""
