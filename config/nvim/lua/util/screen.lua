---@class rc.Screen
local M = {}

M.transparent = function()
  vim.cmd("hi Normal guibg=none")
  vim.cmd("hi LineNr guifg=none")
  vim.cmd("hi LineNr guibg=none")
  vim.cmd("hi SignColumn guibg=none")
  vim.cmd("hi SignColumn guifg=none")
end

--- スクリーンの属性を返す
---@return integer 高さ,integer
M.get_screen_attrs = function()
  local height = vim.api.nvim_get_option_value("lines", {})
  local width = vim.api.nvim_get_option_value("columns", {})
  return height, width
end

return M
