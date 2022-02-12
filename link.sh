#!/bin/bash

dotvim=~/.vim
dotconfig=~/.config

if [ ! -e $dotvim ]; then
  mkdir -p $dotvim
fi

if [ ! -e $dotconfig ]; then
  mkdir -p $dotconfig
fi
dc_target='
nvim
alacritty
i3
i3status
'
for target in $dc_target; do
  if [ ! -e $dotconfig/$target ]; then
    mkdir -p $dotconfig/$target
  fi
done

if [ ! -e ~/.vimrc ]; then
  ln -s $PWD/.vimrc ~/.vimrc
fi

if [ ! -e ~/.zshrc ]; then
  ln -s $PWD/.zshrc ~/.zshrc
fi

if [ ! -e ~/.tmux.conf ]; then
  ln -s $PWD/.tmux.conf ~/.tmux.conf
fi

if [ ! -e ~/.xprofile ]; then
  ln -s $PWD/.xprofile ~/.xprofile
fi

if [ ! -e $dotvim/dein.toml ]; then
  ln -s $PWD/vim/dein.toml $dotvim/dein.toml
fi

if [ ! -e $dotvim/dein_lazy.toml ]; then
  ln -s $PWD/vim/dein_lazy.toml $dotvim/dein_lazy.toml
fi

if [ ! -e $dotvim/coc.toml ]; then
  ln -s $PWD/vim/coc.toml $dotvim/coc.toml
fi

if [ ! -e $dotconfig/nvim/init.vim ]; then
  ln -s $PWD/config/nvim/init.vim $dotconfig/nvim/init.vim
fi

if [ ! -e $dotconfig/starship.toml ]; then
  ln -s $PWD/config/starship.toml $dotconfig/starship.toml
fi

if [ ! -e $dotconfig/alacritty/alacritty.yml ]; then
  
  ln -s $PWD/config/alacritty/alacritty.yml $dotconfig/alacritty/alacritty.yml
fi

if [ ! -e $dotconfig/i3/config ]; then
  ln -s $PWD/config/i3/config $dotconfig/i3/config
fi

if [ ! -e $dotconfig/i3status/config ]; then
  ln -s $PWD/config/i3status/config $dotconfig/i3status/config
fi
