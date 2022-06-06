#!/bin/bash

function log() {
  local log_level=$1
  local msg=$2
  echo "[$log_level] $msg"
}

function log_info() {
  log 'INFO' "$*"
}

function log_error() {
  log 'ERROR' "$*"
}

function log_warn() {
  log 'WARN' "$*"
}

function mkdir_if_not_exists() {
  if [[ -z $1 ]]; then
    log_error "functinon 'mkdir_if_not_exists' needs one argument (directory) ."
    exit 1
  fi
  local dir=$1
  if [[ ! -d $dir ]]; then
    log_info "make directory '${dir}'"
    mkdir -p $dir
  fi
}

