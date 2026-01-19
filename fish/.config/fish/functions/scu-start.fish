function scu-start --wraps='systemctl --user start' --description 'alias scu-start systemctl --user start'
    systemctl --user start $argv
end
