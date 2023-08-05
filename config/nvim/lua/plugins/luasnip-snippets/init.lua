---@class rc.LuaSnippet
---@field filetype string
---@field snippets table|fun(luasnip: any):table
local M = {
  filetype = "all",
  snippets = {},
}

local ls = require("luasnip")

---@param opts rc.LuaSnippet
---@return rc.LuaSnippet
function M:new(opts)
  vim.validate({
    ["opts.filetype"] = { opts.filetype, "s" },
    ["opts.snippets"] = { opts.snippets, { "t", "f" } },
  })
  local ins = vim.tbl_deep_extend("force", self, opts)
  return setmetatable(ins, { __index = M })
end

function M:add_snippets()
  local snippets = nil
  if type(self.snippets) == "table" then
    snippets = self.snippets
  elseif type(self.snippets) == "function" then
    snippets = self.snippets(ls)
  end
  ls.add_snippets(self.filetype, snippets or {})
end

return M
