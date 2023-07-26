local targets = {
  "folke/lazy.nvim",
  "hrsh7th/nvim-cmp",
}

---@return string[]
local function f()
  local r = {}
  local lazy_plugins = require("lazy").plugins() or {}
  for _, plugin in ipairs(lazy_plugins) do
    if vim.tbl_contains(targets, plugin[1]) then
      table.insert(r, plugin.dir)
    end
  end
  return r
end

return f()
