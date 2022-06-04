#!/bin/bash

source ./bin/functions.sh

log_info "start install"

os=`uname -a | cut -d' ' -f 1`
log_info "os name: $os"
echo ""

# deploy for linux and mac 
for deploy_file in `find . -type f -regextype posix-egrep -regex '.*/deploy\.sh$'`; do
  source $deploy_file
done

# create environmental settings
case $os in
  Linux ) source ./linux_gen.sh ;;
  Darwin ) source ./mac_gen.sh ;;
esac
