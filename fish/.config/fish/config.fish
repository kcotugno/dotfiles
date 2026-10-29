if status is-interactive
    if not functions -q zd
        fish_vi_key_bindings

        if command -sq starship
            starship init fish | source
        end

        if command -sq mise
            mise activate fish | source
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

    set -l chrome (command -s brave-origin brave)
    if set -q chrome[1]
        set -x CHROME_PATH $chrome[1]
    end

    if ! test -d "$HOME/devel"
        mkdir -p "$HOME/devel"
    end

    set -x DEVPATH "$HOME/devel"

    set -x RIPGREP_CONFIG_PATH "$HOME/.config/ripgreprc"
end

set -l xdg_data "$HOME/.local/share"
set -q XDG_DATA_HOME; and set xdg_data $XDG_DATA_HOME
set -l xdg_cache "$HOME/.cache"
set -q XDG_CACHE_HOME; and set xdg_cache $XDG_CACHE_HOME
set -l xdg_bin "$HOME/.local/bin"
set -q XDG_BIN_HOME; and set xdg_bin $XDG_BIN_HOME

set -x GOPATH "$xdg_data/go"
set -x GOMODCACHE "$xdg_cache/go/mod"
set -x GOBIN "$xdg_bin"
