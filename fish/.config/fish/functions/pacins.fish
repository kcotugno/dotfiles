function pacins --wraps='sudo pacman -S' --description 'alias pacins sudo pacman -S'
    sudo pacman -S $argv
end
