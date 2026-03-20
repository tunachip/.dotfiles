local wezterm = require("wezterm")

return {
  -- Font
  font = wezterm.font("BlexMono Nerd Font"),
  font_size = 14.0,

  -- Hide tab bar completely
  enable_tab_bar = false,

  default_cursor_style = "BlinkingBlock",

  colors = {
    cursor_fg = "#000000",
    cursor_bg = "#6b8e23",
    cursor_border = "#6b8e23",
  },
  cursor_thickness = 9,
  cursor_blink_rate = 300,
  animation_fps = 1
}
