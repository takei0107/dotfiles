---@module "util.screen"
local screen = require("util.screen")

local M = {}

---@class FloatConfig
---@field relative FloatConfig.relative|nil
---@field anchor FloatConfig.anchor|nil
---@field width integer|nil
---@field height integer|nil
---@field row integer|nil
---@field col integer|nil
---@field border FloatConfig.border|nil

---@enum FloatConfig.relative
M.FloatRelative = {
  EDITOR = "editor",
  WIN = "win",
  CURSOR = "cursor",
  MOUSE = "mouse",
}

---@enum FloatConfig.anchor
M.FloatAnchor = {
  NORTHWEST = "NW",
  NORTHEAST = "NE",
  SOUTHWEST = "SW",
  SOUTHEAST = "SE",
}

---@enum FloatConfig.border
M.FloatBorder = {
  NONE = "none",
  SINGLE = "single",
  DOUBLE = "double",
  ROUNDED = "rounded",
  SOLID = "solid",
  SHADOW = "shadow",
}

---@return FloatConfig
local function default_config()
  local screen_height, screen_width = screen.get_screen_attrs()
  local float_win_height = math.floor(screen_height * 0.8)
  local float_win_width = math.floor(screen_width * 0.8)
  local float_win_row = (screen_height - float_win_height) / 2
  local float_win_col = (screen_width - float_win_width) / 2
  ---@type FloatConfig
  return {
    relative = M.FloatRelative.EDITOR,
    anchor = M.FloatAnchor.NORTHWEST,
    width = float_win_width,
    height = float_win_height,
    row = float_win_row,
    col = float_win_col,
    border = M.FloatBorder.SINGLE,
  }
end

--- フロートウィンドウ作成用のコンフィグを作成する
---@param override FloatConfig|nil
---@return FloatConfig
M.make_float_config = function(override)
  override = override or {}
  vim.validate({ opts = { override, "table" } })

  local default = default_config()
  return vim.tbl_deep_extend("force", default, override)
end

return M
