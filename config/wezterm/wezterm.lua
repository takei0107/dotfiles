local wezterm = require('wezterm');

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local nerd_icons = {
    nvim = wezterm.nerdfonts.custom_vim,
    vim = wezterm.nerdfonts.custom_vim,
    bash = wezterm.nerdfonts.dev_terminal,
    zsh = wezterm.nerdfonts.dev_terminal,
    ssh = wezterm.nerdfonts.mdi_server,
    top = wezterm.nerdfonts.mdi_monitor,
  }
  local pane = tab.active_pane
  local p_name = basename(pane.foreground_process_name)
  local icon = nerd_icons[p_name]
  local index = tab.tab_index + 1
  local p_name_formated = index .. ": " .. basename(pane.foreground_process_name)
  local title = icon and icon .. "  " .. p_name_formated or p_name_formated
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
  color_scheme = "FishTank",
  window_background_opacity = 0.8,
}
