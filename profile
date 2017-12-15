if [[ -n "$(echo $SHELL | grep zsh)" ]]; then
	export ZSH="$HOME/.oh-my-zsh"

	ZSH_THEME="jispwoso"

	plugins=(git)
	source "$ZSH/oh-my-zsh.sh"
fi

if [[ -d "$HOME/devel" ]]; then
	export DEVPATH="$HOME/devel"
else
	export DEVPATH="$HOME"
fi

if [[ -d "$DEVPATH/android/android-sdk" ]]; then
	export ANDROID_SDK="$HOME/dev/android/android-sdk"
fi

if [[ -d "$DEVPATH/android/android-ndk" ]]; then
	export ANDROID_NDK="$HOME/dev/android/android-ndk"
fi

which go &> /dev/null
if (( !$? )) && [[ -d "$DEVPATH/go" ]]; then
	export GOPATH="$DEVPATH/go"
fi

function passgen () {
	local len="$1"
	local lower="$2"

	echo "$len" | grep -q '^[0-9]+$'
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

if [[ -f "$HOME/.ssh-sentinel.sh" ]]; then
	source "$HOME/.ssh-sentinel.sh"
fi

alias e="$EDITOR"
alias s="du -sh"

alias l="ls -lah"
alias ll="ls -lh"
alias la="ls -lah"
