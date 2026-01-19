function scu-enable --wraps='systemctl --user enable' --description 'alias scu-enable systemctl --user enable'
    systemctl --user enable $argv
end
