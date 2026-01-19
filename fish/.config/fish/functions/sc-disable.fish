function sc-disable --wraps='sudo systemctl disable' --description 'alias sc-disable sudo systemctl disable'
    sudo systemctl disable $argv
end
