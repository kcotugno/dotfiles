function sc-status --wraps='systemctl status' --description 'alias sc-status systemctl status'
    systemctl status $argv
end
