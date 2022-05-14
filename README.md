# dotfiles

## requires

### must
- git
- brew(mac)
- yay(arch)

### packages
- alacritty
- autorandr
- arandr
- bat
- bitwarden
- copyq
- deno
- dmenu
- fcitx-mozc
- fd
- feh
- fzf
- ghq
- i3-gaps
- i3lock
- i3status
- neovim
- noto-fonts-emoji
- ntp
- ripgrep
- rofi
- slack
- starship
- tree
- vim
- vivaldi
- volta
- wezterm
- xclip
- xss-lock
- zinit
- zsh

### manual install
- nerdfont
- sdkman

## install

### Git


### Homebrew

- Mac
  ```
  $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

### Zsh


### nerdfont

- Mac
  ```
  $ /opt/homebrew/bin/brew tap homebrew/cask-fonts
  $ /opt/homebrew/bin/brew install --cask font-<FontName>-nerd-font
  ```

- Linux (or Mac)
  ```
  $ git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
  $ ./install.sh <FontName>
  ```

### sdkman & java

- 共通
  ```
  $ curl -s "https://get.sdkman.io?rcupdate=false" | bash
  $ export SDKMAN_DIR="$HOME/.sdkman"
  $ [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
  $ sdk install java
  ```

## シンボリックリンク作成

```
$ cd [インストールディレクトリ]
$ chmod +x link.sh
$ ./link.sh
$ source ~/.zshrc
$ vim .
```
