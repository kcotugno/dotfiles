function gfa --wraps='git fetch --all --tags --prune' --description 'alias gf git fetch --all --tags --prune'
    git fetch --all --tags --prune $argv
end
