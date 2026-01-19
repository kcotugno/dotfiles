function scu-stop --wraps='systemctl --user stop' --description 'alias sc-stop systemctl --user stop'
    systemctl --user stop $argv
end
