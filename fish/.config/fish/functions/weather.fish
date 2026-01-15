function weather
    set loc $argv[1]
    if test -z "$loc"
        set loc "Phoenix%2C%20Arizona%2C%20United%20States"
    end
    curl -sSL "https://wttr.in/$loc?"
end
