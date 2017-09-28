export DEVPATH=$HOME/dev

if [[ -n "$(echo $SHELL | grep zsh)" ]]; then
	export ZSH=$HOME/.oh-my-zsh

	ZSH_THEME="jispwoso"

	plugins=(git)
	source $ZSH/oh-my-zsh.sh
fi

if [[ -d "$HOME/.rvm" ]]; then
	export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

	[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

if [[ -d "$DEVPATH/android/android-sdk" ]]; then
	export ANDROID_SDK=$HOME/dev/android/android-sdk
fi

if [[ -d "$DEVPATH/android/android-ndk" ]]; then
	export ANDROID_NDK=$HOME/dev/android/android-ndk
fi

which go &> /dev/null
if (( !$? )); then
	export GOPATH=$DEVPATH/go
fi

function passgen () {
	local len=$1
	local lower=$2

	echo $len | grep -q '^[0-9]+$'
	if (( ! $? )); then
		len=32
	fi

	if [[ "$lower" = "true" ]]; then
		local tr1="[:upper:]"
		local tr2="[:lower:]"
	fi

	cat /dev/urandom | base64 | head -c $len | tr -d "\n" | \
		tr "$tr1" "$tr2" && echo
}

export EDITOR='nvim'

alias l="ls -lah"
alias ll="ls -lh"
alias la="ls -lah"

source $HOME/.ssh-sentinel.sh
