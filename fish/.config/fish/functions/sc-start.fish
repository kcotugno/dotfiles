function sc-start --wraps='sudo systemctl start' --description 'alias sc-start sudo systemctl start'
    sudo systemctl start $argv
end
