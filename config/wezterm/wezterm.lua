local wezterm = require('wezterm');

return {
  default_cwd = wezterm.home_dir,
  font = wezterm.font(
    "BitstreamVeraSansMono Nerd Font", { weight = "Regular", }
  ),
  use_ime = true,
  font_size = 14.0,
  color_scheme = "Ayu Mirage",
  window_background_opacity = 0.8,
}
