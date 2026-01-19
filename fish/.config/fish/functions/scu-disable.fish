function scu-disable --wraps='systemctl --user disable' --description 'alias scu-disable systemctl --user disable'
    systemctl --user disable $argv
end
