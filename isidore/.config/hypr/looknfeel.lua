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
