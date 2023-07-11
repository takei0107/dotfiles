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
HISTFILE=$HOME/.zsh_history

export TLDR_LANGUAGE="ja"

alias ll='ls -alt --color'
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

if [[ -f $HOME/.fzf.zsh ]]; then
	source $HOME/.fzf.zsh
else 
	[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
	[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
fi

if type fzf > /dev/null 2>&1; then
	export FZF_DEFAULT_OPTS='--cycle'
	function fzf_repo () {
		local selected_dir=$(ghq list -p | fzf --reverse)
		if [ -n "$selected_dir" ]; then
			BUFFER="cd ${selected_dir}"
			zle accept-line
		fi
		zle clear-screen
	}
	zle -N fzf_repo
	bindkey '^]' fzf_repo

	function fzf_ssh () {
		local selected_dir=$(find $HOME/.ssh/** -name config -or -name _config | xargs cat | grep "Host " | awk -F' ' '{print $2}' | sort --reverse | fzf --reverse)
		if [ -n "$selected_dir" ]; then
			BUFFER="ssh ${selected_dir}"
			zle accept-line
		fi
		zle clear-screen
	}
	zle -N fzf_ssh
	bindkey '^h' fzf_ssh

	alias fcd='cd `dirname $(fzf)`'
fi

function workdir () {
	local work=$HOME/work
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

if type scrot > /dev/null 2>&1; then
	if [[ ! -d $HOME/Pictures/screenshots ]]; then
		mkdir $HOME/Pictures/screenshots
	fi
	alias scsho='scrot -s -e '\''mv $f ~/Pictures/screenshots'\'
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [[ -d "$HOME/.sdkman" ]]; then
	export SDKMAN_DIR="$HOME/.sdkman"
	[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# for ubuntu
is_fdfind=$(type fdfind > /dev/null 2>&1;echo $?)
is_batcat=$(type batcat > /dev/null 2>&1;echo $?)
if [[ $is_fdfind -eq 0 ]] || [[ $is_batcat -eq 0 ]]; then
	if [[ ! -d ~/.local/bin ]]; then
		mkdir ~/.local/bin
	fi
	if [[ $is_fdfind -eq 0 ]]; then
		ln -fs $(which fdfind) ~/.local/bin/fd
	fi
	if [[ $is_batcat -eq 0 ]]; then
		ln -fs $(which batcat) ~/.local/bin/bat
	fi
fi

typeset -U path # $path にすでにある値は追加されない
path=(
	# volta管理下のnpmでインストールされたツールを利用するために必要
	$HOME/.volta/bin(N-/)
	$HOME/go/bin/(N-/)
	$HOME/.cargo/bin(N-/)
	$HOME/.local/bin(N-/)
	/opt/homebrew/bin(N-/)
	$path
)

# Starship
if type starship > /dev/null 2>&1; then
	eval "$(starship init zsh)"
fi

# volta
if type volta > /dev/null 2>&1; then
	export VOLTA_HOME="$HOME/.volta"
fi

[[ -f $HOME/.zshrc_local ]] && source $HOME/.zshrc_local
