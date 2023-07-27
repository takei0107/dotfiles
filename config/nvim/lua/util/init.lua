---@class rc.Util
local M = {}

---@param modname string
---@param callback fun(module: any)
---@return boolean|any, string|nil pcallと一緒
M.safeRequire = function(modname, callback)
  vim.validate({
    modname = { modname, "string" },
    callback = { callback, "function" },
  })
  local ok, errOrMod = pcall(require, modname)
  if not ok then
    return false, errOrMod
  end
  return pcall(callback, errOrMod)
end

---@param modname string モジュール名
M.safeRequireWithSideEffect = function(modname)
  vim.validate({
    modname = { modname, "string" },
  })
  local ok, err = pcall(require, modname)
  if not ok then
    print("safeRequire() failed. error: " .. err)
  end
end

--- スクリーンの属性を返す
---@return integer 高さ,integer
M.get_screen_attrs = function()
  local height = vim.api.nvim_get_option_value("lines", {})
  local width = vim.api.nvim_get_option_value("columns", {})
  return height, width
end


---@class FloatConfig
---@field relative FloatConfig.relative
---@field anchor FloatConfig.anchor
---@field width integer
---@field height integer
---@field row integer
---@field col integer
---@field border FloatConfig.border

---@enum FloatConfig.relative
M.FloatRelative = {
  EDITOR = "editor",
  WIN = "win",
  CURSOR = "cursor",
  MOUSE = "mouse"
}

---@enum FloatConfig.anchor
M.FloatAnchor = {
  NORTHWEST = "NW",
  NORTHEAST = "NE",
  SOUTHWEST = "SW",
  SOUTHEAST = "SE"
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
  local screen_height, screen_width = M.get_screen_attrs()
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
    border = M.FloatBorder.SINGLE
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
