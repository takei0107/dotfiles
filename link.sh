#!/usr/bin/env bash

set -e
set -u

[[ ! -d $HOME/.config ]] && mkdir "$HOME"/.config
[[ ! -d $HOME/.vim ]] && mkdir "$HOME"/.vim

# links define
declare -A linksdef
linksdef=(
  [$PWD/.vimrc]=$HOME/.vimrc
  [$PWD/.zshrc]=$HOME/.zshrc
  [$PWD/.ideavimrc]=$HOME/.ideavimrc
)

for entry in "$PWD"/config/*;
do
  linksdef[$entry]=$HOME/.config
done

for entry in "$PWD"/vim/*;
do
  linksdef[$entry]=$HOME/.vim
done

# check linksdef
ok=true
for target in "${!linksdef[@]}"
do
  if [[ ! -e $target ]]; then
    echo "[ERR] entry:$target is not exist."
    ok=false
  else
    linkname=${linksdef[$target]}
    if [[ -z $linkname ]]; then
      echo "[ERR] linkname for $target is null or 0 length."
      ok=false
    fi
  fi
done
if [[ $ok == false ]]; then
  echo "$0 is failed."
  return 1
fi

# unlink & link
for target in "${!linksdef[@]}"
do
  linkname=${linksdef[$target]}
  if [[ -L $linkname ]]; then
    unlink "$linkname"
  fi
  ln -fis "$target" "$linkname"
done

