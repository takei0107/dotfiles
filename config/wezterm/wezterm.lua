local wezterm = require('wezterm');

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- タブの表示
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

-- フォント決定
-- TODO ローカル設定がアーキ依存なのでもっと良くしたい
local e_font = "JetBrains Mono" -- 組み込みフォント(デフォルト)
local e_font_size = 12.0
if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  -- linux
  e_font = "RobotoMono Nerd Font"
  e_font_size = 18.0
elseif wezterm.target_triple == "x86_64-apple-darwin" then
  -- mac
  e_font = "BitstreamVeraSansMono Nerd Font"
  e_font_size = 14.0
end

return {
  default_cwd = wezterm.home_dir,
  font = wezterm.font(
    e_font, { weight = "Regular" }
  ),
  use_ime = true,
  font_size = e_font_size,
  color_scheme = "FishTank",
  window_background_opacity = 0.8,
}
