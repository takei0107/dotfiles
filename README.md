# dotfiles

## requires

- Git
- Homebrew
- zsh
  - zinit
- vim
- starship
  - nerdfont
- volta
- ghq
- sdkman
- alacritty

## install

### Git

- Linux
  - apt
    ```
    $ sudo apt install git
    ```

- Mac
  - brew
    ```
    $ /opt/homebrew/bin/brew install git
    ```

### Homebrew

- Mac
  ```
  $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

### Zsh

- Linux
  - apt
    ```
    $ type zsh > /dev/null 2>&1 || sudo apt install zsh
    $ chsh -s $(which zsh)
    ログインし直す
    ```

- Mac
  デフォルトでzsh(のはず)

### zinit

- 共通
  ```
  $ ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
  $ mkdir -p "$(dirname $ZINIT_HOME)"
  $ git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  ```
  
### vim

- Linux
  - arch
     ```
    $ yay -S gvim
    ```

### starship

- Linux
  ```
  $ sh -c "$(curl -fsSL https://starship.rs/install.sh)"
  ```

- Mac
  ```
  $ /opt/homebrew/bin/brew install starship
  ```

### nerdfont

- Mac
  ```
  $ /opt/homebrew/bin/brew tap homebrew/cask-fonts
  $ /opt/homebrew/bin/brew install --cask font-<FONT NAME>-nerd-font
  ```

- Linux (or Mac)
  ```
  $ git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
  $ ./install.sh <FontName>
  ```

### volta & nodejs

- 共通
  ```
  $ curl https://get.volta.sh | bash -s -- --skip-setup
  $ ~/.volta/bin/volta install node
  ```

### ghq

- Linux
  - arch
    ```
    yay -S ghq
    ```

- Mac
  ```
  $ brew install ghq
  ```

### sdkman & java

- 共通
  ```
  $ curl -s "https://get.sdkman.io?rcupdate=false" | bash
  $ export SDKMAN_DIR="$HOME/.sdkman"
  $ [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
  $ sdk install java
  ```

### Alacritty

- Linux
  - arch
  ```
  $ yay -S alacritty
  ```

## シンボリックリンク作成

```
$ cd [インストールディレクトリ]
$ chmod +x link.sh
$ ./link.sh
$ source ~/.zshrc
$ vim .
```
