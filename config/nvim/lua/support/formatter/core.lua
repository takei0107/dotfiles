---@class rc.FormatCofingBase
---@field enabled? boolean
---@field enableAutoOnSave? boolean
---@field cmd? string
---@field ft? string[]
---@field excmd? string

---@class rc.FormatCofing: rc.FormatCofingBase
---@field cmd string
---@field ft string[]
---@field excmd? string

---@class rc.FormatCofings
---@field configs table<string, rc.FormatCofing>
local M = {
  configs = {},
}

M.configs.stylua = {
  cmd = "stylua -",
  ft = { "lua" },
  enabled = false,
  enableAutoOnSave = false,
  excmd = "Stylua",
}

---@param opts table<string, rc.FormatCofingBase>
M.setup = function(opts)
  local configs = vim.tbl_deep_extend("force", M.configs, opts)

  local formatterUtil = require("util.formatter")

  for key, config in pairs(configs) do
    if config.enabled then
      local formatter = formatterUtil:new(config.cmd)
      local id = vim.api.nvim_create_augroup(("%s-format"):format(key), {})
      vim.api.nvim_create_autocmd("FileType", {
        group = id,
        pattern = config.ft,
        callback = function(event)
          ---@type number
          local bufnr = event.buf

          if config.excmd and type(config.excmd) == "string" then
            vim.api.nvim_buf_create_user_command(bufnr, config.excmd, function()
              formatter:formatting()
            end, {
              bang = false,
              nargs = 0,
            })
          end

          if config.enableAutoOnSave then
            formatter:formattingOnSave({
              buffer = bufnr,
              group = id,
            })
          end
        end,
      })
    end
  end
end

return M
