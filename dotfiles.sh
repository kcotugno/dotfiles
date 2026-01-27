#!/usr/bin/env bash
set -eo pipefail

base_stow_packages=(ansible fish git mise nvim tmux)
gui_stow_packages=(ghostty)

user=$(whoami)

if [ "$HOME" = "" ]; then
	echo "HOME must be set"
	exit 1
fi

function is_sudo() {
	if [ "$SUDO_UID" != "" ]; then
		echo "Please run without sudo"
		exit 1
	fi
}

function detect_os() {
	# Adapted from https://unix.stackexchange.com/a/6348
	if [ -f /etc/os-release ]; then
		# freedesktop.org and systemd
		# shellcheck disable=SC1091
		. /etc/os-release
		OS=Arch

	elif type lsb_release >/dev/null 2>&1; then
		# linuxbase.org
		OS=$(lsb_release -si)
	elif [ -f /etc/lsb-release ]; then
		# For some versions of Debian/Ubuntu without lsb_release command
		# shellcheck disable=SC1091
		. /etc/lsb-release
		OS=$DISTRIB_ID
	elif [ -f /etc/debian_version ]; then
		# Older Debian/Ubuntu/etc.
		OS=Debian
	elif [ -n "${TERMUX_VERSION+x}" ]; then
		OS=termux
	else
		# Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
		OS=$(uname -s)
	fi

	OS=$(echo "$OS" | tr '[:upper:]' '[:lower:]')
}

function detect_package_manager() {
	local sudo
	if [ "$user" != "root" ]; then sudo="sudo "; fi

	if [ "$OS" = "arch" ]; then
		install_package_cmd="${sudo}pacman -S --noconfirm"
		check_package_cmd="pacman -Q"
	elif [ "$OS" = "debian" ]; then
		install_package_cmd="${sudo}apt-get install -y"
		check_package_cmd="dpkg -l"
	elif [ "$OS" = "darwin" ]; then
		if [ "$user" = "root" ]; then
			echo "Running as root on macOS is unsupported"
			exit 1
		fi

		install_package_cmd="brew install"
		check_package_cmd="brew list --formula"
	elif [ "$OS" = "termux" ]; then
		install_package_cmd="pkg install"
		check_package_cmd="dpkg -l"
	else
		echo "Unknown and unsupported package manager"
		exit 1
	fi
}

function is_hyprland_active() {
	if pgrep -x Hyprland >/dev/null 2>&1; then
		return 0
	else
		return 1
	fi
}

function is_display_active() {
	if [ -n "$WAYLAND_DISPLAY" ] || [ -n "$DISPLAY" ]; then
		return 0
	else
		return 1
	fi
}

function check_package_installed() {
	$check_package_cmd "$1" &>/dev/null || return 1
}

function install_packages() {
	for package in "${packages[@]}"; do
		echo -n "Installing $package..."
		if check_package_installed "$package"; then
			echo "already installed, skipping"
			continue
		fi

		$install_package_cmd "$package" >/dev/null 2>&1
		echo "done"
	done
}

function install_mise() {
	if check_package_installed mise; then
		echo "Mise is already installed...skipping"
		return
	fi

	if [[ $(command -v mise) ]]; then
		echo "Mise is already installed...updating"
		mise self-update
		return
	fi

	curl https://mise.run | sh
	mise install
}

function install_stow_packages() {
	echo "Installing stow packages" "${stow_packages[@]}"
	stow "${stow_packages[@]}"
}

function remove_stow_packages() {
	local packages_to_remove=("$@")
	if [ "${#packages_to_remove[@]}" -eq 0 ]; then
		echo "No packages specified for removal"
		return 1
	fi
	if [ "${packages_to_remove[0]}" = "all" ]; then
		packages_to_remove=("${base_stow_packages[@]}" "${gui_stow_packages[@]}" "hyprland")
	fi
	echo "Removing stow packages" "${packages_to_remove[@]}"
	stow --delete "${packages_to_remove[@]}"
}

is_sudo
detect_os
detect_package_manager

command="install"
ui_auto=true
ui=false
packages_to_remove=()

while [[ $# -gt 0 ]]; do
	case $1 in
	install)
		command="install"
		shift
		;;
	uninstall)
		command="uninstall"
		shift
		packages_to_remove=("$@")
		break
		;;
	-u | --ui)
		ui=true
		ui_auto=false
		shift
		;;
	--no-ui)
		ui=false
		ui_auto=false
		shift
		;;
	-h | --help)
		echo "Usage: $0 [install] [-u|--ui] [--no-ui] | uninstall <packages...> | uninstall all"
		exit 0
		;;
	*)
		echo "Unknown option: $1"
		echo "Usage: $0 [install] [-u|--ui] [--no-ui] | uninstall <packages...> | uninstall all"
		exit 1
		;;
	esac
done

if $ui_auto && is_display_active; then
	ui=true
fi

if [ "$command" = "uninstall" ]; then
	remove_stow_packages "${packages_to_remove[@]}"
elif [ "$command" = "install" ]; then
	nvim_plugin_theme=no
	packages=(git stow lazygit fzf ripgrep fd nvim zoxide)
	if $ui; then
		packages+=(ghostty)
	fi
	install_packages
	install_mise

	stow_packages=("${base_stow_packages[@]}")
	if $ui; then
		stow_packages+=("${gui_stow_packages[@]}")
		if is_hyprland_active; then
			stow_packages+=("hyprland")
			nvim_plugin_theme=yes
		fi
	fi

	install_stow_packages

	if [ "$nvim_plugin_theme" = "yes" ]; then
		echo "Install omarchy neovim theme syslink..."
		ln -snf "${HOME}/.config/omarchy/current/theme/neovim.lua" "${HOME}/.config/nvim/lua/plugins/theme.lua"
	fi
fi
