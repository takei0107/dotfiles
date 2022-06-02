#!/bin/bash

CONFIG_DIR=$HOME/.config
CACHE_DIR=$HOME/.cache
VIM_CONFIG_DIR=$CONFIG_DIR/vim
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

function mkdir_if_not_exists() {
  local dir=$1
  if [[ ! -d $dir ]]; then
    echo "make directory '${dir}'"
    mkdir -p $dir
  fi
}

function generate_vimfile() {
  VIM_LOCALRC=$HOME/.vimrc.env
  cat << EOF > $VIM_LOCALRC
if has('nvim')
  let s:config_dir = fnamemodify('${NVIM_CONFIG_DIR}', ':p')
  let s:cache_dir = fnamemodify('${NVIM_CACHE_DIR}', ':p')
else
  let s:config_dir = fnamemodify('${VIM_CONFIG_DIR}', ':p')
  let s:cache_dir = fnamemodify('${VIM_CACHE_DIR}', ':p')
endif
let s:config_vars = {
\ 'config_dir' : s:config_dir,
\ 'cache_dir' : s:cache_dir,
\}
if exists('ExportConfigValues')
  call ExportConfigValues(s:config_vars)
endif
EOF
}

# make directories
for dir in $DIRS; do
  mkdir_if_not_exists $dir
done

# generate local files
generate_vimfile
