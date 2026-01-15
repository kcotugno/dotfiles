function gcmsg --wraps='git commit --message' --description 'alias gcmsg git commit --message'
    git commit --message $argv
end
