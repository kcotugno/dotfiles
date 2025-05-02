#!/usr/bin/env bash
set -eo pipefail

user=$(whoami)
alacritty_conf=".alacritty.toml"

if [ "x$HOME" = "x" ]; then
	echo "HOME must be set"
	exit 1
fi

function is_sudo() {
	if [ "x$SUDO_UID" != "x" ]; then
		echo "Please run without sudo"
		exit 1
	fi
}

function detect_os() {
	# Adapted from https://unix.stackexchange.com/a/6348
	if [ -f /etc/os-release ]; then
		# freedesktop.org and systemd
		. /etc/os-release
		OS=Arch
		VER=$VERSION_ID
	elif type lsb_release >/dev/null 2>&1; then
		# linuxbase.org
		OS=$(lsb_release -si)
		VER=$(lsb_release -sr)
	elif [ -f /etc/lsb-release ]; then
		# For some versions of Debian/Ubuntu without lsb_release command
		. /etc/lsb-release
		OS=$DISTRIB_ID
		VER=$DISTRIB_RELEASE
	elif [ -f /etc/debian_version ]; then
		# Older Debian/Ubuntu/etc.
		OS=Debian
		VER=$(cat /etc/debian_version)
	elif [ -n "${TERMUX_VERSION+x}" ]; then
		OS=termux
		VER=$TERMUX_VERSION
	else
		# Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
		OS=$(uname -s)
		VER=$(uname -r)
	fi

	OS=$(echo "$OS" | tr '[:upper:]' '[:lower:]')
}

function detect_package_manager() {
	local sudo
	if [ "x$user" != "xroot" ]; then sudo="sudo "; fi

	if [ "x$OS" = "xarch" ]; then
		install_package_cmd="${sudo}pacman -S --noconfirm"
		check_package_cmd="pacman -Q"
	elif [ "x$OS" = "xdebian" ]; then
		install_package_cmd="${sudo}apt-get install -y"
		check_package_cmd="dpkg -l"
	elif [ "x$OS" = "xdarwin" ]; then
		if [ "x$user" = "xroot" ]; then
			echo "Running as root on macOS is unsupported"
			exit 1
		fi

		install_package_cmd="brew install"
		check_package_cmd="brew list --formula"
	elif [ "x$OS" = "xtermux" ]; then
		install_package_cmd="pkg install"
		check_package_cmd="dpkg -l"
	else
		echo "Unknown and unsupported package manager"
		exit 1
	fi
}

function check_package_installed() {
	$check_package_cmd "$1" &>/dev/null || return 1
}

function install_git() {
	if check_package_installed lazygit; then
		echo "Git is already installed...skipping"
		return
	fi

	echo "Installing git..."
	$install_package_cmd lazygit
}

function install_oh_my_zsh() {
	local oh_my_zsh_dir="$HOME/.oh-my-zsh"
	if [ -d "$oh_my_zsh_dir" ]; then
		echo "Oh My Zsh is already installed"
		return
	fi

	echo "Installing Oh My Zsh..."
	git -C "$HOME" clone https://code.cotugno.family/kevin/ohmyzsh.git "$(basename "$oh_my_zsh_dir")"
}

function install_mise() {
	if [[ $(command -v mise) ]]; then
		echo "Mise is already installed...updating"
		mise self-update
		return
	fi

	curl https://mise.run | sh
	mise install
}

function install_files() {
	for file in $(cat install.txt); do
		echo "Installing $file"

		if [ "$(dirname "$file")" != "." ]; then
			mkdir -p "$HOME/$(dirname "$file")"
		fi
		cp "$file" "$HOME/$file"
	done

	local alacritty_themes=(".alacritty.dark.toml" ".alacritty.light.toml")
	for theme in ${alacritty_themes[@]}; do
		echo "Installing $theme"
		local destination="$HOME/$theme"
		cp ".alacritty.toml" "$destination"
		cat "$theme" >>"$destination"

		if [[ "$theme" == ".alacritty.dark.toml" ]]; then
			(cd $HOME && ln -sf "$(basename $destination)" "./$alacritty_conf")
		fi
	done
}

function remove_files() {
	for file in $(cat remove.txt); do
		echo "Removing $file"

		rm -f "$HOME/$file"
	done
}

is_sudo
detect_os
detect_package_manager
install_git
install_oh_my_zsh
install_mise
install_files
remove_files
