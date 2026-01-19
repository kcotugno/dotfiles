function pacsearch --wraps='pacman -Ss' --description 'alias pacsearch pacman -Ss'
    pacman -Ss $argv
end
