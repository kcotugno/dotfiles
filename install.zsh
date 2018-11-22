#!/usr/bin/env zsh

## TODO walk the file tree instead of manually linking files

link="ln -s"
rm="rm -rf"

emacs_dir="$HOME/.emacs.d"
nvim_dir="$HOME/.config/nvim"

function create_directories {
	if [[ ! -d "$emacs_dir" ]]; then
		mkdir "$emacs_dir"
	fi

	if [[ ! -d "$nvim_dir" ]]; then
		mkdir "$nvim_dir"
	fi
}

function uninstall {
	eval $rm "$HOME/.zshrc"
	eval $rm "$emacs_dir/init.el"
	eval $rm "$emacs_dir/themes"
	eval $rm "$HOME/.tmux.conf"
	eval $rm "$nvim_dir/autoload"
	eval $rm "$nvim_dir/init.vim"
	eval $rm "$HOME/.Xresources"
	eval $rm "$HOME/.ssh-sentinel"
}

function install {
	create_directories

	eval $link "$PWD/.emacs.d/init.el" "$emacs_dir/init.el"
	eval $link "$PWD/.emacs.d/themes/" "$emacs_dir/themes"
	eval $link "$PWD/.zshrc" "$HOME/.zshrc"
	eval $link "$PWD/.tmux.conf" "$HOME/.tmux.conf"
	eval $link "$PWD/.ssh-sentinel" "$HOME/.ssh-sentinel"
	eval $link "$PWD/.config/nvim/autoload" "$nvim_dir/autoload"
	eval $link "$PWD/.config/nvim/init.vim" "$nvim_dir/init.vim"

	which xrdb &> /dev/null
	xrdb_exists=$?
	if (( !xrdb_exists )); then
		eval $link "$PWD/.Xresources" "$HOME/.Xresources"
		xrdb "$PWD/.Xresources"
	fi
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
