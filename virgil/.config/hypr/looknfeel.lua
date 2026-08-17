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
