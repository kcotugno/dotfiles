function sc-stop --wraps='sudo systemctl stop' --description 'alias sc-stop sudo systemctl stop'
    sudo systemctl stop $argv
end
