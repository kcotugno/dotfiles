local oh_my_zsh="$HOME/.oh-my-zsh"
source $HOME/.ssh-sentinel

if [[ -d "$oh_my_zsh" ]]; then
	local theme="jispwoso"

	export ZSH="$oh_my_zsh"
	export ZSH_THEME="$theme"

	plugins=(git)
	source "$oh_my_zsh/oh-my-zsh.sh"
fi

if [[ -d "$HOME/devel" ]]; then
	export DEVPATH="$HOME/devel"
else
	export DEVPATH="$HOME"
fi

if [[ -z "$USER" ]]; then
	export USER=$(whoami)
fi

if [[ -d "$DEVPATH/android/android-sdk" ]]; then
	export ANDROID_SDK="$DEVPATH/android/android-sdk"
fi

if [[ -d "$DEVPATH/android/android-ndk" ]]; then
	export ANDROID_NDK="$DEVPATH/android/android-ndk"
fi

which go &> /dev/null
if (( !$? )) && [[ -d "$DEVPATH/go" ]]; then
	export GOPATH="$DEVPATH/go"
	export PATH="$GOPATH/bin:$PATH"
fi

if [[ -d "$HOME/.cargo" ]]; then
	export PATH=$HOME/.cargo/bin:$PATH
fi

which nvim &> /dev/null
neovim="$?"

which vim &> /dev/null
vim="$?"

if (( !$neovim )); then
	export EDITOR="nvim"
elif (( !$vim )); then
	export EDITOR="vim"
else
	export EDITOR="vi"
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

alias e="$EDITOR"
alias s="du -sh"

alias tmux="tmux -2"

alias l="ls -lah"
alias ll="ls -lh"
alias la="ls -lah"
