---@class rc.CmpSource
---@field name string lazy.nvimで使うリポジトリ名
---@field sourceName string nvim-cmpのソース名
---@field option table|nil nvim-cmpの各ソースのオプション
---@field types rc.CmpType[] どのモードでソースを利用するか
---@field format fun(vim_item: vim.CompletedItem): vim.CompletedItem ":h cmp-config.formatting.format"

local cmpType = require("plugins.cmp.cmp-type")

---@type rc.CmpSource[]
local sources = {
  {
    name = "hrsh7th/cmp-nvim-lsp",
    sourceName = "nvim_lsp",
    option = {},
    format = function(vim_item)
      vim_item.kind = "lsp"
      return vim_item
    end,
    types = { cmpType.EDITOR },
  },
  {
    name = "hrsh7th/cmp-buffer",
    sourceName = "buffer",
    option = {
      -- ウィンドウ表示状態のバッファ
      get_bufnrs = function()
        local bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          bufs[vim.api.nvim_win_get_buf(win)] = true
        end
        return vim.tbl_keys(bufs)
      end,
    },
    format = function(vim_item)
      vim_item.kind = "buffer"
      return vim_item
    end,
    types = { cmpType.EDITOR, cmpType.CMD_EX, cmpType.CMD_SEARCH },
  },
  {
    name = "hrsh7th/cmp-path",
    sourceName = "path",
    option = {},
    format = function(vim_item)
      vim_item.kind = "path"
      return vim_item
    end,
    types = {cmpType.EDITOR, cmpType.CMD_EX, cmpType.CMD_SEARCH}
  },
  {
    name = "hrsh7th/cmp-cmdline",
    sourceName = "cmdline",
    format = function(vim_item)
      vim_item.kind = "cmd"
      return vim_item
    end,
    types = {cmpType.CMD_EX}
  }
}

setmetatable(sources, {
  -- nvim-cmpのセットアップ時に設定する'sources'の値を取得できる
  ---@param self rc.CmpSource[]
  ---@param type rc.CmpType
  ---@return cmp.SourceConfig[]
  __call = function(self, type)
    ---@type cmp.SourceConfig[]
    local t = {}
    for _, source in ipairs(self) do
      if vim.tbl_contains(source.types, type) then
        ---@type cmp.SourceConfig
        local s = { name = source.sourceName }
        if source.option then
          s.option = source.option
        end
        table.insert(t, s)
      end
    end
    return t
  end,

  -- nvim-cmpのソース名でインデックスできる
  ---@param self rc.CmpSource[]
  ---@param sourceName string
  ---@return rc.CmpSource|nil
  __index = function(self, sourceName)
    for _, source in ipairs(self) do
      if source.sourceName == sourceName then
        return source
      end
    end
    return nil
  end,
})

return sources
