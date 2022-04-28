bindkey -v

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' verbose true

setopt auto_cd
setopt no_beep
setopt sharehistory
setopt histignorealldups

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

export TLDR_LANGUAGE="ja"

[[ -f ~/.zshrc_local ]] && source ~/.zshrc_local
alias ll='ls -alt'
alias tailf='tail -f'

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]];then
  source "${ZINIT_HOME}/zinit.zsh"
  autoload -Uz compinit && compinit
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit

  zinit light zsh-users/zsh-autosuggestions
  zinit light zdharma-continuum/fast-syntax-highlighting
fi

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

if type fzf > /dev/null 2>&1; then
  function fzf_src () {
    local selected_dir=$(ghq list -p | fzf)
    if [ -n "$selected_dir" ]; then
      BUFFER="cd ${selected_dir}"
      zle accept-line
    fi
    zle clear-screen
  }
  zle -N fzf_src
  bindkey '^]' fzf_src

  alias fcd='cd `dirname $(fzf)`'
fi

function workdir () {
  local work=~/work
  if [[ ! -d $work ]]; then
    mkdir $work
  fi
  local today=$(date '+%Y%m%d')
  local today_work="$work/$today"
  if [[ ! -d $today_work ]]; then
    mkdir $today_work
  fi
  cd $today_work
  echo change dir to \'`pwd`\'
}

typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  # volta管理下のnpmでインストールされたツールを利用するために必要
  ~/.volta/bin(N-/)
  /usr/local/go/bin(N-/)
  ~/go/bin/(N-/)
  $path
)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Starship
if type starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
