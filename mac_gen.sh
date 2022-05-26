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

# make directories
if [[ ! -d $VIM_CONFIG_DIR ]]; then
  mkdir -p $VIM_CONFIG_DIR
fi
if [[ ! -d $VIM_CACHE_DIR ]]; then
  mkdir -p $VIM_CACHE_DIR
fi
if [[ ! -d $NVIM_CONFIG_DIR ]]; then
  mkdir $NVIM_CONFIG_DIR
fi
if [[ ! -d $NVIM_CACHE_DIR ]]; then
  mkdir $NVIM_CACHE_DIR
fi
if [[ ! -d $DEIN_DIR ]]; then
  mkdir $DEIN_DIR
fi

# generate vimfile
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
