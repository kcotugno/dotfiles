function pacup --wraps='sudo pacman -Syu' --description 'alias pacup sudo pacman -Syu'
    sudo pacman -Syu $argv
end
