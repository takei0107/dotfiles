---@class rc.LSConfig
---@field root_dir fun(filename: string, bufnr: integer)|nil
---@field filetypes string[]|nil
---@field autostart boolean|nil
---@field single_file_support boolean|nil
---@field on_new_config fun(new_config: rc.LSConfig, new_root_dir: string)|nil
---@field capabilities table<string, string|table|boolean|function>|nil
---@field cmd string[]|nil
---@field handlers function[]
---@field init_options table<string, string|table|boolean>
---@field on_attach fun(client: integer, bufnr: integer)
---@field settings table<string, string|table|boolean>

---@type rc.LSConfig
local M = {}

---@return rc.LSConfig
---@param override rc.LSConfig
function M:new(override)
  local instance = vim.tbl_deep_extend("force", self, override)
  return setmetatable(instance, {
    __index = self,
  })
end

return M
