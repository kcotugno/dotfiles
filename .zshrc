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

	if [[ $(command -v tmux) ]]; then
		# Only start/attach if no existing session with client.
		if [[ (( $(tmux list-sessions -F "#{session_attached}" 2>/dev/null || echo 0) = 0 )) && ! -v "ZSH_TMUX_AUTOSTART" ]]; then
		export ZSH_TMUX_AUTOSTART=true
		fi
		plugins+=(tmux)
	fi

	if [[ $(command -v mise) ]]; then
		plugins+=(mise)
		eval "$(mise activate zsh)"
	fi

	if [[ $(command -v fzf) ]]; then plugins+=(fzf); fi

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

ANDROID_HOME="$DEVPATH/Android/Sdk"
if [[ -d "$ANDROID_HOME" ]]; then
	export ANDROID_HOME
	export PATH="$ANDROID_HOME/emulator:$PATH"
	export PATH="$ANDROID_HOME/platform-tools:$PATH"
fi

if [[ $(command -v nvim) ]]; then
	export EDITOR="nvim"
elif [ $(command -v vim) ]; then
	export EDITOR="vim"
else
	export EDITOR="vi"
fi

if [[ $(command -v uname) ]] && uname -r | grep -iq microsoft-standard; then source "$HOME/.wsl.zsh"; fi

if [[ $(command -v fzf) && $(command -v fd) ]]; then
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

if [[ $(command -v fd) ]]; then
	function _p {
		compadd $(fd --no-ignore --max-depth=1 --type=d . $DEVPATH | xargs basename -a)
	}

	compdef _p p
fi

if [[ $(command -v com.brave.Browser) ]]; then
	export CHROME_PATH=$(which com.brave.Browser)
fi

if [[ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

function clean_file_backslash {
  for i in *; do new=${i//\\/\/}; newd=$(dirname "$new"); mkdir -p "$newd"; mv "$i" "$new"; done
}

function system_color_theme () {
	case "$(uname -s)" in
		Darwin)
			if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" != "Dark" ]]; then
				echo "light"
				return
			fi
			;;
		Linux)
			if [[ "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
				if (( $(qdbus org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read "org.freedesktop.appearance" "color-scheme") == 2 )); then
					echo "light"
					return
				fi
			fi
			;;
	esac

	echo "dark"
}

function sync_alacritty_theme() {
	local theme=$(system_color_theme)
	local dark_theme=".alacritty.dark.toml"
	local light_theme=".alacritty.light.toml"
	local alacritty_conf=".alacritty.toml"

	if [[ ! -e "$HOME/$dark_theme" || ! -e "$HOME/$light_theme" ]]; then
		echo "Dark and/or light theme files do not exist"
		return
	fi

	if [[ "$theme" == "light" ]]; then
		(cd $HOME && ln -sf "$light_theme" "$alacritty_conf")
	else
		(cd $HOME && ln -sf "$dark_theme" "$alacritty_conf")
	fi
}

alias e='$EDITOR'
alias s="du -sh"
alias sd="du -hd 1"

alias tmux="tmux -2"

alias l="ls -lah"
alias ll="ls -lh"
alias la="ls -lah"
alias hexenc="hexdump -e '1/1 \"%02x\"'"

sync_alacritty_theme
