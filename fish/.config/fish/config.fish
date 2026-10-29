if status is-interactive
    if not functions -q zd
        fish_vi_key_bindings

        if command -sq starship
            starship init fish | source
        end

        if command -sq zoxide
            zoxide init fish | source
            alias cd z
        end

        if command -sq fzf
            fzf --fish | source
        end

        if command -sq eza
            alias ls "eza -lh --group-directories-first --icons=auto"
        end

        alias g git
    end

    if functions -q zd; or command -sq eza
        alias l ls
    else
        alias l "ls -lh"
    end
end

if not functions -q zd; and command -sq mise
    if status is-interactive
        mise activate fish | source
    else
        mise activate fish --shims | source
    end
end

if not set -q CHROME_PATH
    set -l chrome (command -s brave-origin brave)
    if set -q chrome[1]
        set -gx CHROME_PATH $chrome[1]
    end
end

set -q DEVPATH; or set -gx DEVPATH "$HOME/devel"
set -q RIPGREP_CONFIG_PATH; or set -gx RIPGREP_CONFIG_PATH "$HOME/.config/ripgreprc"

set -l xdg_data "$HOME/.local/share"
set -q XDG_DATA_HOME; and set xdg_data $XDG_DATA_HOME
set -l xdg_cache "$HOME/.cache"
set -q XDG_CACHE_HOME; and set xdg_cache $XDG_CACHE_HOME
set -l xdg_bin "$HOME/.local/bin"
set -q XDG_BIN_HOME; and set xdg_bin $XDG_BIN_HOME

set -q GOPATH; or set -gx GOPATH "$xdg_data/go"
set -q GOMODCACHE; or set -gx GOMODCACHE "$xdg_cache/go/mod"
set -q GOBIN; or set -gx GOBIN "$xdg_bin"

if status is-interactive; and not test -d "$DEVPATH"
    mkdir -p "$DEVPATH"
end
