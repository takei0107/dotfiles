#!/bin/bash

set -eu

LSDIR=~/.local/share/nvim/language-servers

bin=$LSDIR/lua-language-server/bin/lua-language-server

if [[ ! -f $bin ]]; then
	exit 1
fi

exec "$bin" "$@"
