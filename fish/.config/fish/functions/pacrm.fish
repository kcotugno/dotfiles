function pacrm --wraps='sudo pacman -Rncus' --description 'alias pacrm sudo pacman -Rncus'
    sudo pacman -Rncus $argv
end
