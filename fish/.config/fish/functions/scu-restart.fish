function scu-restart --wraps='systemctl --user restart' --description 'alias scu-restart systemctl --user restart'
    systemctl --user restart $argv
end
