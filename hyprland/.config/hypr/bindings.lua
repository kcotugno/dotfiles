for _, keys in ipairs({
    "SUPER + SHIFT + SLASH",
    "SUPER + SHIFT + G",
    "SUPER + SHIFT + C",
    "SUPER + SHIFT + E",
    "SUPER + SHIFT + ALT + G",
    "SUPER + SHIFT + CTRL + A",
}) do
    hl.unbind(keys)
end

-- o.bind("SUPER + SHIFT + G", "Signal", 'omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop --password-store=gnome-libsecret"')
o.bind("SUPER + SHIFT + G", "Signal", { omarchy = "signal", focus = true }) -- 'omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop --password-store=gnome-libsecret"')
o.bind("SUPER + SHIFT + SLASH", "Passwords", { launch = "bitwarden-desktop" })
o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://app.fastmail.com/calendar/week", focus = true })
o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://app.fastmail.com/", focus = true })
o.bind("SUPER + SHIFT + ALT + G", "Slack", { webapp = "https://app.slack.com/client", focus = true })

-- omarchy-agent redirects to ~/Work when it starts in $HOME; land in ~/devel first.
o.bind("SUPER + SHIFT + CTRL + A", "Agent", "cd ~/devel && omarchy-agent --pick")

-- o.bind("SUPER + SHIFT + ALT + M", "Facebook", webapp("https://facebook.com/", vars.facebook_profile))
-- o.bind("SUPER + ALT + L", "Screenoff", "screenoff")
