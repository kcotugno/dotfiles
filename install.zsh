#!/usr/bin/env zsh

set -e

link="ln -sr"
rm="rm -rf"

function uninstall {
	eval $rm "$HOME/.zshrc"
	eval $rm "$HOME/.emacs.d"
	eval $rm "$HOME/.tmux.conf"
	eval $rm "$HOME/.config/nvim"
}

function install {
	eval $link ".emacs.d" "$HOME/.emacs.d"
	eval $link ".zshrc" "$HOME/.zshrc"
	eval $link ".tmux.conf" "$HOME/.tmux.conf"
	eval $link ".config/nvim" "$HOME/.config/nvim"
}

if [[ "$1" == "uninstall" ]]; then
	echo -n "Uninstalling..."
	uninstall
	echo "Done"
elif [[ "$1" == "install" || "$1" == "" ]]; then
	echo -n "Installing..."
	uninstall
	install
	echo "Done"
else
	echo "Unknown command \`$1\`"
fi
