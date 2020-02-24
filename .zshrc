oh_my_zsh="$HOME/.oh-my-zsh"

if [[ -f "$oh_my_zsh/oh-my-zsh.sh" ]]; then

	export ZSH="$oh_my_zsh"
	export ZSH_THEME="$theme"
	export DISABLE_UPDATE_PROMPT=true

	plugins=(git)
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

which rbenv &> /dev/null
if (( !$? )); then
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

function passgen () {
	local len="$1"
	local lower="$2"

	echo "$len" | grep -qE '^[0-9]+$'
	if (( $? )); then
		len=32
	fi

	local result=`cat /dev/urandom | base64 | tr -d "\n" | head -c "$len"`
	if [[ "$lower" = "true" ]]; then
		local tr1="[:upper:]"
		local tr2="[:lower:]"
		result=`echo "$result" | tr "$tr1" "$tr2"`
	fi

	echo -n "$result"
}

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
