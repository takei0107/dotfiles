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
  e_font_size = 13.0
elseif wezterm.target_triple == "aarch64-apple-darwin" then
  -- mac
  e_font = "BitstreamVeraSansMono Nerd Font"
  e_font_size = 11.5
end

return {
  default_cwd = wezterm.home_dir,
  font = wezterm.font(
    e_font, { weight = "Medium" }
  ),
  use_ime = true,
  font_size = e_font_size,
  color_scheme = "FishTank",
  window_background_opacity = 0.8,
  keys = {
    -- tab actions
    {key="t", mods="ALT", action = wezterm.action({SpawnTab="CurrentPaneDomain"})},
    {key="1", mods="ALT", action = wezterm.action({ActivateTab=0})},
    {key="2", mods="ALT", action = wezterm.action({ActivateTab=1})},
    {key="3", mods="ALT", action = wezterm.action({ActivateTab=2})},
    {key="4", mods="ALT", action = wezterm.action({ActivateTab=3})},
    {key="5", mods="ALT", action = wezterm.action({ActivateTab=4})},
    {key="6", mods="ALT", action = wezterm.action({ActivateTab=5})},
    {key="7", mods="ALT", action = wezterm.action({ActivateTab=6})},
    {key="8", mods="ALT", action = wezterm.action({ActivateTab=7})},
    {key="9", mods="ALT", action = wezterm.action({ActivateTab=8})},
    {key="a", mods="ALT", action = "ShowTabNavigator"},
    {key="q", mods="ALT", action = wezterm.action({CloseCurrentTab = {confirm = false}})},

    -- pane actions
    {key="%", mods="SHIFT|ALT", action = wezterm.action({SplitVertical={domain="CurrentPaneDomain"}})},
    {key="\"", mods="SHIFT|ALT", action = wezterm.action({SplitHorizontal={domain="CurrentPaneDomain"}})},
    { key = "h", mods="ALT", action=wezterm.action{ActivatePaneDirection="Left"}},
    { key = "l", mods="ALT", action=wezterm.action{ActivatePaneDirection="Right"}},
    { key = "k", mods="ALT", action=wezterm.action{ActivatePaneDirection="Up"}},
    { key = "j", mods="ALT", action=wezterm.action{ActivatePaneDirection="Down"}},
  },
  --debug_key_events = true,
}
