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
  ln -fs $PWD/.vimrc ~/.vimrc
fi

if [ ! -e ~/.zshrc ]; then
  ln -fs $PWD/.zshrc ~/.zshrc
fi

if [ ! -e ~/.tmux.conf ]; then
  ln -fs $PWD/.tmux.conf ~/.tmux.conf
fi

if [ ! -e ~/.xprofile ]; then
  ln -fs $PWD/.xprofile ~/.xprofile
fi

if [ ! -e $dotvim/dein.toml ]; then
  ln -fs $PWD/vim/dein.toml $dotvim/dein.toml
fi

if [ ! -e $dotvim/dein_lazy.toml ]; then
  ln -fs $PWD/vim/dein_lazy.toml $dotvim/dein_lazy.toml
fi

if [ ! -e $dotvim/coc.toml ]; then
  ln -fs $PWD/vim/coc.toml $dotvim/coc.toml
fi

if [ ! -e $dotvim/lsp.toml ]; then
  ln -fs $PWD/vim/lsp.toml $dotvim/lsp.toml
fi

if [ ! -e $dotvim/ddc.toml ]; then
  ln -fs $PWD/vim/ddc.toml $dotvim/ddc.toml
fi

if [ ! -e $dotvim/nvim.toml ]; then
  ln -fs $PWD/vim/nvim.toml $dotvim/nvim.toml
fi

if [ ! -e $dotconfig/nvim/init.vim ]; then
  ln -fs $PWD/config/nvim/init.vim $dotconfig/nvim/init.vim
fi

if [ ! -e $dotconfig/starship.toml ]; then
  ln -fs $PWD/config/starship.toml $dotconfig/starship.toml
fi

if [ ! -e $dotconfig/alacritty/alacritty.yml ]; then
  
  ln -fs $PWD/config/alacritty/alacritty.yml $dotconfig/alacritty/alacritty.yml
fi

if [ ! -e $dotconfig/i3/config ]; then
  ln -fs $PWD/config/i3/config $dotconfig/i3/config
fi

if [ ! -e $dotconfig/i3status/config ]; then
  ln -fs $PWD/config/i3status/config $dotconfig/i3status/config
fi
