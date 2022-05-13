local wezterm = require('wezterm');

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = pane.pane_id .. ": " .. basename(pane.foreground_process_name)
  return {
    {Text=" " .. title .. " "},
  }
end)

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
