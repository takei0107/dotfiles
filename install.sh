#!/bin/bash

source ./bin/functions.sh

log_info "start install"

os=`uname -a | cut -d' ' -f 1`
log_info "os name: $os"
echo ""

# deploy for linux and mac 
if [[ $os == 'Darwin' ]]; then
  cmd="find -E . -type f -regex '.*\/deploy\.sh$'"
else
  cmd="find . -type f -regextype posix-egrep -regex '.*/deploy\.sh$'"
fi
for deploy_file in `eval $cmd`; do
  source $deploy_file
done

# create environmental settings
case $os in
  Linux ) source ./linux_gen.sh ;;
  Darwin ) source ./mac_gen.sh ;;
esac
