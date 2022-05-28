#!/bin/bash

CONFIG_DIR=$HOME/.config
CACHE_DIR=$HOME/.cache
VIM_CONFIG_DIR=$CONFIG_DIR/vim
VIM_CACHE_DIR=$CACHE_DIR/vim
NVIM_CONFIG_DIR=$CONFIG_DIR/nvim
NVIM_CACHE_DIR=$CACHE_DIR/nvim
# directory for Shougo/dein.vim
DEIN_DIR=$CACHE_DIR/dein
# !!!ディレクトリでdein.vimの存在チェックするのでここで作成は不要 !!!
DEIN_REPO_DIR=$DEIN_DIR/repos/github.com/Shougo/dein.vim

declare -a DIRS="
$CONFIG_DIR
$CACHE_DIR
$VIM_CONFIG_DIR
$VIM_CACHE_DIR
$NVIM_CONFIG_DIR
$NVIM_CACHE_DIR
$DEIN_DIR
"

function mkdir_if_not_exists() {
  local dir=$1
  if [[ ! -d $dir ]]; then
    if [[ $dir != $DEIN_REPO_DIR ]]; then
      echo "make directory '${dir}'"
      mkdir -p $dir
    fi
  fi
}

function generate_vimfile() {
  VIM_LOCALRC=$HOME/.vimrc.local
  cat << EOF > $VIM_LOCALRC
if has('nvim')
  let g:config_dir = expand('${NVIM_CONFIG_DIR}' .. '/')
  let g:cache_dir = expand('${NVIM_CACHE_DIR}' .. '/')
else
  let g:config_dir = expand('${VIM_CONFIG_DIR}' .. '/')
  let g:cache_dir = expand('${VIM_CACHE_DIR}' .. '/')
endif
let g:dein_dir = expand('${DEIN_DIR}' .. '/')
let g:dein_repo_dir = expand('${DEIN_REPO_DIR}' .. '/')
EOF
}

# make directories
for dir in $DIRS; do
  mkdir_if_not_exists $dir
done

# generate local files
generate_vimfile
