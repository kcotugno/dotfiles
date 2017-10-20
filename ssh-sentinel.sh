#!/usr/bin/env bash

file="$HOME/.ssh-agent"
found=0

which ssh-agent &> /dev/null
if (( $? )); then
	exit 1
fi

if [[ -e $file ]]; then
	sockenv=`cat $file | grep SSH_AUTH_SOCK`
	pidenv=`cat $file | grep SSH_AGENT_PID`
	sock=`echo "$sockenv" | grep -oP "(?<=\=)/.*$"`
	pid=`echo "$pidenv" | grep -o "[0-9]*"`
	proc=`ps ax | grep "^ $pid.*ssh-agent"`

	if [[ -S "$sock" && -O "$sock" && -n "$proc" ]]; then
		export "$sockenv"
		export "$pidenv"
		found=1
	fi
fi

if (( ! $found )); then
	export `ssh-agent -s | grep -oP "^.+(?=; export)" | tee "$file"`
fi

chmod 600 "$file"
