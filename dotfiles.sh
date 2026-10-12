#!/usr/bin/env bash
set -eo pipefail

base_stow_packages=(ansible fish git mise nvim tmux)
gui_stow_packages=()

user=$(whoami)
hostname=$(hostname)

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
		case " $ID $ID_LIKE " in
		*" arch "*) OS=Arch ;;
		*" debian "* | *" ubuntu "*) OS=Debian ;;
		*) OS=$ID ;;
		esac

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
		update_package_index_cmd="${sudo}apt-get update"
		install_package_cmd="${sudo}env DEBIAN_FRONTEND=noninteractive apt-get install -y"
		check_package_cmd="dpkg_installed"
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

# `dpkg -l` succeeds for removed-but-not-purged packages, so check the status.
function dpkg_installed() {
	dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

function check_package_installed() {
	$check_package_cmd "$1" &>/dev/null || return 1
}

# Translate a package name to the one used by the current OS's package manager.
function package_name() {
	if [ "$OS" = "debian" ]; then
		case $1 in
		# Debian's neovim is too old for LazyVim; install_mise_tools installs it.
		nvim) ;;
		fd) echo fd-find ;;
		*) echo "$1" ;;
		esac
	else
		echo "$1"
	fi
}

function install_packages() {
	local failed=()

	if [ -n "$update_package_index_cmd" ]; then
		echo -n "Updating package index..."
		$update_package_index_cmd >/dev/null 2>&1
		echo "done"
	fi

	for package in "${packages[@]}"; do
		package=$(package_name "$package")
		if [ -z "$package" ]; then continue; fi
		echo -n "Installing $package..."
		if check_package_installed "$package"; then
			echo "already installed, skipping"
			continue
		fi

		if $install_package_cmd "$package" >/dev/null 2>&1; then
			echo "done"
		else
			echo "failed"
			failed+=("$package")
		fi
	done

	# Debian ships fd as `fdfind` to avoid a name clash.
	if [ "$OS" = "debian" ] && command -v fdfind >/dev/null && ! command -v fd >/dev/null; then
		mkdir -p "${HOME}/.local/bin"
		ln -sf "$(command -v fdfind)" "${HOME}/.local/bin/fd"
	fi

	if [ "${#failed[@]}" -gt 0 ]; then
		echo "Failed to install:" "${failed[@]}"
	fi
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
	# mise.run installs to ~/.local/bin, which may not be on PATH yet.
	export PATH="${HOME}/.local/bin:${PATH}"
}

# Runs after stow so the global mise config is in place.
function install_mise_tools() {
	if [ "$OS" = "debian" ]; then
		mkdir -p "${HOME}/.config/mise/conf.d"
		printf '[tools]\nneovim = "latest"\n' >"${HOME}/.config/mise/conf.d/debian.toml"
	fi

	echo "Installing mise tools"
	(cd "$HOME" && mise install)
}

function bootstrap_nvim() {
	local nvim_config="${HOME}/.config/nvim"

	if [ ! -f "${nvim_config}/init.lua" ]; then
		echo "Bootstrapping LazyVim starter into ${nvim_config}..."
		local tmp
		tmp=$(mktemp -d)
		git clone --depth 1 https://github.com/LazyVim/starter "${tmp}/starter"
		rm -rf "${tmp}/starter/.git"
		mkdir -p "$nvim_config"
		cp -rn "${tmp}/starter/." "${nvim_config}/"
		rm -rf "$tmp"
	fi

	local target
	while IFS= read -r target; do
		rm -f "${HOME}/${target#nvim/}"
	done < <(find nvim -mindepth 1 -type f)
}

function install_stow_packages() {
	echo "Installing stow packages" "${stow_packages[@]}"
	stow --no-folding "${stow_packages[@]}"
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
	packages=(git stow lazygit fzf ripgrep fd nvim zoxide)

	install_packages
	install_mise

	stow_packages=("${base_stow_packages[@]}")
	if $ui; then
		stow_packages+=("${gui_stow_packages[@]}")
		if is_hyprland_active; then
			stow_packages+=("hyprland")
		fi
	fi

	if ls "./${hostname}" &>/dev/null ; then
		stow_packages+=("${hostname}")
	fi

	if [[ " ${stow_packages[*]} " == *" nvim "* ]]; then
		bootstrap_nvim
	fi

	install_stow_packages
	install_mise_tools
fi
