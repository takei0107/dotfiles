local wezterm = require('wezterm');

return {
  default_cwd = wezterm.home_dir,
  font = wezterm.font(
    "BitstreamVeraSansMono Nerd Font",
    {
      weight = "Bold",
    }
  ),
  use_ime = true,
  font_size = 13.0,
  color_scheme = "Ayu Mirage",
  window_background_opacity = 0.8,
}
