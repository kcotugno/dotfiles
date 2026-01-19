function sc-enable --wraps='sudo systemctl enable' --description 'alias sc-enable sudo systemctl enable'
    sudo systemctl enable $argv
end
