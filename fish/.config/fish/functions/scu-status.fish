function scu-status --wraps='systemctl --user status' --description 'alias scu-status systemctl --user status'
    systemctl --user status $argv
end
