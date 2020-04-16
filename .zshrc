oh_my_zsh="$HOME/.oh-my-zsh"

if [[ -f "$oh_my_zsh/oh-my-zsh.sh" ]]; then

	export ZSH="$oh_my_zsh"
	export DISABLE_UPDATE_PROMPT=true
	export ZSH_TMUX_AUTOSTART=true

	if (( !${+ZSH_THEME} )); then
		export ZSH_THEME="simple"
	fi

	export plugins=(
		fzf
		git
		tmux
	)

	source "$oh_my_zsh/oh-my-zsh.sh"
fi

if [[ -d "$HOME/devel" ]]; then
	export DEVPATH="$HOME/devel"
elif [[ -d "$HOME/workspace" ]]; then
	export DEVPATH="$HOME/workspace"
else
	export DEVPATH="$HOME"
fi

if [[ -z "$USER" ]]; then
	USER=$(whoami)
	export USER
fi

if [ $(command -v go) ] && [[ -d "$DEVPATH/go" ]]; then
	export GOPATH="$DEVPATH/go"
	export PATH="$GOPATH/bin:$PATH"
fi

if [[ -d "$HOME/.cargo" ]]; then
	export PATH=$HOME/.cargo/bin:$PATH
fi

if [[ -d "$HOME/.rbenv" ]]; then
	export PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(rbenv init -)"
fi

if [[ $(command -v nvim) ]]; then
	export EDITOR="nvim"
elif [ $(command -v vim) ]; then
	export EDITOR="vim"
else
	export EDITOR="vi"
fi

if [[ -f "$HOME/work.zsh" ]]; then
	source "$HOME/work.zsh"
fi

function weather() {
	local loc=$1
	if [[ -z "$loc" ]]; then
		loc="Phoenix, AZ"
	fi

	curl -sSL "wttr.in/$loc?"
}

alias e='$EDITOR'
alias s="du -sh"

alias tmux="tmux -2"

alias l="ls -lah"
alias ll="ls -lh"
alias la="ls -lah"
