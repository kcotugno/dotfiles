mkdir -p "$HOME/.local/bin" && export PATH="$HOME/.local/bin:$PATH"
if [[ -f "$HOME/.work.zsh" ]]; then source "$HOME/.work.zsh"; fi

oh_my_zsh="$HOME/.oh-my-zsh"

if [[ -f "$oh_my_zsh/oh-my-zsh.sh" ]]; then
	export ZSH="$oh_my_zsh"

	if (( !${+ZSH_THEME} )); then
		export ZSH_THEME="simple"
	fi

	export plugins=(
		themes
		git
		isodate
		urltools
	)

	if command -v tmux &>/dev/null; then
		# Only start/attach if no existing session with client.
		if [[ (( $(tmux list-sessions -F "#{session_attached}" 2>/dev/null || echo 0) = 0 )) && ! -v "ZSH_TMUX_AUTOSTART" ]]; then
		export ZSH_TMUX_AUTOSTART=true
		fi
		plugins+=(tmux)
	fi

	command -v mise &>/dev/null && plugins+=(mise)

	command -v fzf &>/dev/null && plugins+=(fzf)

	command -v systemctl &>/dev/null && plugins+=(systemd)

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

if command -v go &>/dev/null; then
	export GOPATH="$DEVPATH/go"
	export PATH="$GOPATH/bin:$PATH"
fi

if [[ -d "$HOME/.cargo" ]]; then
	export PATH=$HOME/.cargo/bin:$PATH
fi

ANDROID_HOME="$DEVPATH/Android/Sdk"
if [[ -d "$ANDROID_HOME" ]]; then
	export ANDROID_HOME
	export PATH="$ANDROID_HOME/emulator:$PATH"
	export PATH="$PATH:$ANDROID_HOME/platform-tools"
fi

if command -v nvim &>/dev/null; then
	export EDITOR="nvim"
elif command -v vim &>/dev/null; then
	export EDITOR="vim"
else
	export EDITOR="vi"
fi
export SUDO_EDITOR="$EDITOR"

if command -v uname &>/dev/null && uname -r | grep -iq microsoft-standard; then source "$HOME/.wsl.zsh"; fi

if command -v fzf &>/dev/null && command -v fd &>/dev/null; then
	export FZF_DEFAULT_COMMAND="fd --type f --hidden --no-ignore --follow --exclude .git"
fi

function weather() {
	local loc=$1
	if [[ -z "$loc" ]]; then
		loc="Phoenix%2C%20Arizona%2C%20United%20States"
	fi

	curl -sSL "https://wttr.in/$loc?"
}

function p {
	local project="$1"

	if [[ ! -d "$DEVPATH/$project" ]]; then echo "Unknown project $project"; return; fi

	cd "$DEVPATH/$project"
}

if command -v fd &>/dev/null; then
	function _p {
		compadd $(fd --no-ignore --max-depth=1 --type=d . $DEVPATH | xargs basename -a)
	}

	compdef _p p
fi

if command -v brave &>/dev/null; then
	export CHROME_PATH=$(which brave)
fi

if [[ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]]; then
	export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

function clean_file_backslash {
	for i in *; do new=${i//\\/\/}; newd=$(dirname "$new"); mkdir -p "$newd"; mv "$i" "$new"; done
}

OMARCHY_PATH="$HOME/.local/share/omarchy"
if [[ -d "$OMARCHY_PATH" ]]; then
	export PATH="$OMARCHY_PATH/bin:$PATH"
	source "$HOME/.omarchy.functions.zsh"
	source "$HOME/.omarchy.aliases.zsh"
fi

alias e='$EDITOR'

alias s="du -sh"
alias sd="du -hd 1"

alias tmux="tmux -2"

alias hexenc="hexdump -e '1/1 \"%02x\"'"

if command -v eza &>/dev/null; then
	alias l="ls"
	alias ll="ls"
else
	alias l="ls -lh"
	alias ll="ls"
	alias la="ls -lah"
fi

