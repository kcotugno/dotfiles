oh_my_zsh="$HOME/.oh-my-zsh"

if [[ -f "$oh_my_zsh/oh-my-zsh.sh" ]]; then
	export ZSH="$oh_my_zsh"
	export DISABLE_AUTO_UPDATE=true

	if (( !${+ZSH_THEME} )); then
		export ZSH_THEME="simple"
	fi

	export plugins=(
		themes
		fzf
		git
	)

	if [[ $(command -v tmux) ]]; then
		if [[ ! -v "ZSH_TMUX_AUTOSTART" ]]; then export ZSH_TMUX_AUTOSTART=true; fi
		plugins+=(tmux)
	fi


	if [[ $(command -v systemctl) ]]; then
		plugins+=(systemd)
	fi

	source "$oh_my_zsh/oh-my-zsh.sh"
fi

if [[ -d "$HOME/workspace" ]]; then
	export DEVPATH="$HOME/workspace"
else
	mkdir -p "$HOME/devel"
	export DEVPATH="$HOME/devel"
fi

if [[ -z "$USER" ]]; then
	USER=$(whoami)
	export USER
fi

if [[ $(command -v go) ]]; then
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

if [[ -d "$HOME/.nvm" ]]; then
	export NVM_DIR="$HOME/.nvm"

	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [[ $(command -v nvim) ]]; then
	export EDITOR="nvim"
elif [ $(command -v vim) ]; then
	export EDITOR="vim"
else
	export EDITOR="vi"
fi

if [[ $(command -v uname) ]] && uname -r | grep -iq microsoft-standard; then source "$HOME/.wsl.zsh"; fi

if [[ -f "$HOME/.work.zsh" ]]; then source "$HOME/.work.zsh"; fi

if [[ $(command -v fzf) && $(command -v fd) ]]; then
	export FZF_DEFAULT_COMMAND="fd --type f --hidden --no-ignore --follow --exclude .git"
fi

mkdir -p "$HOME/.local/bin" && export PATH="$HOME/.local/bin:$PATH"

function weather() {
	local loc=$1
	if [[ -z "$loc" ]]; then
		loc="Phoenix, AZ"
	fi

	curl -sSL "wttr.in/$loc?"
}

function proj {
	local proj="$1"

	if [[ ! -d "$DEVPATH/$proj" ]]; then echo "Unknown project $proj"; return; fi

	cd "$DEVPATH/$proj"
}

alias e='$EDITOR'
alias s="du -sh"

alias tmux="tmux -2"

alias l="ls -lah"
alias ll="ls -lh"
alias la="ls -lah"
alias hexenc="hexdump -e '1/1 \"%02x\"'"
