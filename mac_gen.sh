#!/bin/bash

CONFIG_DIR=$HOME/.config
CACHE_DIR=$HOME/.cache
VIM_CONFIG_DIR=$HOME/.vim
VIM_CACHE_DIR=$CACHE_DIR/vim
NVIM_CONFIG_DIR=$CONFIG_DIR/nvim
NVIM_CACHE_DIR=$CACHE_DIR/nvim

declare -a DIRS="
$CONFIG_DIR
$CACHE_DIR
$VIM_CONFIG_DIR
$VIM_CACHE_DIR
$NVIM_CONFIG_DIR
$NVIM_CACHE_DIR
"

function generate_vimfile() {
  VIM_LOCALRC=$HOME/.vimrc.env
  cat << EOF > $VIM_LOCALRC
if has('nvim')
  let g:config_dir = fnamemodify('${NVIM_CONFIG_DIR}', ':p')
  let g:cache_dir = fnamemodify('${NVIM_CACHE_DIR}', ':p')
else
  let g:config_dir = fnamemodify('${VIM_CONFIG_DIR}', ':p')
  let g:cache_dir = fnamemodify('${VIM_CACHE_DIR}', ':p')
endif
EOF
}

# make directories
for dir in $DIRS; do
  mkdir_if_not_exists $dir
done

# generate local files
generate_vimfile
