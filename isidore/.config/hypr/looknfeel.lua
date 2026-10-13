hl.config({
  general = {
    layout = "master",
  },

  master = {
    orientation = "center",
    new_status = "slave",
    slave_count_for_center_master = 0,
  },

  decoration = {
    rounding = 4,
  }
})

hl.unbind("SUPER + L")

o.bind("SUPER + L", "Toggle workspace layout", [=[
    ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.id')
    [[ $ACTIVE_WORKSPACE =~ ^-?[0-9]+$ ]] || exit 1
    CURRENT_LAYOUT=$(hyprctl activeworkspace -j | jq -r '.tiledLayout')
    LAYOUTS_DIR="$HOME/.local/state/omarchy/workspace-layouts"
    LAYOUT_FILE="$LAYOUTS_DIR/$ACTIVE_WORKSPACE.lua"

    [ "$CURRENT_LAYOUT" = "master" ] && NEW_LAYOUT="dwindle" || NEW_LAYOUT="master"

    mkdir -p "$LAYOUTS_DIR"
    printf 'hl.workspace_rule({ workspace = "%s", layout = "%s" })\n' "$ACTIVE_WORKSPACE" "$NEW_LAYOUT" >"$LAYOUT_FILE"

    hyprctl eval "hl.workspace_rule({ workspace = \"$ACTIVE_WORKSPACE\", layout = \"$NEW_LAYOUT\" })" >/dev/null 2>&1
    omarchy-notification-send -g 󱂬 "Workspace layout set to $NEW_LAYOUT"
]=])

-- Brightness: the G9 answers DDC/CI only on HDMI (disabled as an output in
-- monitors.lua), while the picture lives on DP-5. The focused monitor is
-- therefore never the one that can be dimmed, so pin the DDC target explicitly.
for _, keys in ipairs({
    "XF86MonBrightnessUp",
    "XF86MonBrightnessDown",
    "SHIFT + XF86MonBrightnessUp",
    "SHIFT + XF86MonBrightnessDown",
    "ALT + XF86MonBrightnessUp",
    "ALT + XF86MonBrightnessDown",
}) do
    hl.unbind(keys)
end

local brightness_opts = { locked = true, repeating = true }
local function brightness(step)
    return "omarchy-brightness-display --monitor HDMI-A-1 " .. step
end

o.bind("XF86MonBrightnessUp", "Brightness up", brightness("+5%"), brightness_opts)
o.bind("XF86MonBrightnessDown", "Brightness down", brightness("5%-"), brightness_opts)
o.bind("SHIFT + XF86MonBrightnessUp", "Brightness maximum", brightness("100%"), brightness_opts)
o.bind("SHIFT + XF86MonBrightnessDown", "Brightness minimum", brightness("1%"), brightness_opts)
o.bind("ALT + XF86MonBrightnessUp", "Brightness up precise", brightness("+1%"), brightness_opts)
o.bind("ALT + XF86MonBrightnessDown", "Brightness down precise", brightness("1%-"), brightness_opts)
