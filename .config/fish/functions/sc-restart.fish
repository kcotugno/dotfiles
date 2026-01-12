function sc-restart --wraps='sudo systemctl restart' --description 'alias sc-restart sudo systemctl restart'
    sudo systemctl restart $argv
end
