---@class rc.Formatter
---@field private formatFunc function()
local M = {}

---@param cmd string
---@return rc.Formatter
function M:new(cmd)
  -- validate
  vim.validate({
    cmd = { cmd, "s" },
  })

  local instance = setmetatable({}, { __index = M })
  instance.formatFunc = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    local result = vim.system(vim.split(cmd, " "), { stdin = lines }):wait()
    if result.code > 0 then
      vim.notify("Failed to format", vim.log.levels.ERROR)
      return
    end
    local data = result.stdout:gsub("%s*$", "")
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(data, "\n"))
    vim.api.nvim_win_set_cursor(0, cursor)
  end
  return instance
end

function M:formatting()
  self.formatFunc()
end

---@class rc.Formatter.AutoEnableOpts
---@field buffer number
---@field group number

---@param opts rc.Formatter.AutoEnableOpts
function M:formattingOnSave(opts)
  ---@type rc.Formatter.AutoEnableOpts
  opts = vim.tbl_deep_extend("force", {}, opts)
  vim.validate({
    ["opts.buffer"] = {
      opts.buffer,
      { "n" },
    },
    ["opts.group"] = {
      opts.group,
      { "n" },
    },
  })
  vim.api.nvim_create_autocmd({ "BufWrite" }, {
    group = opts.group,
    buffer = opts.buffer,
    callback = function()
      self:formatting()
    end,
  })
end

return M
