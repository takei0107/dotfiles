---@class rc.CmpSource
---@field name string lazy.nvimで使うリポジトリ名
---@field sourceName string nvim-cmpのソース名
---@field option table|nil nvim-cmpの各ソースのオプション
---@field format fun(vim_item: vim.CompletedItem): vim.CompletedItem ":h cmp-config.formatting.format"

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
	},
	{
		name = "hrsh7th/cmp-buffer",
		sourceName = "buffer",
		option = {},
		format = function(vim_item)
			vim_item.kind = "buffer"
			return vim_item
		end,
	},
}

setmetatable(sources, {
	-- nvim-cmpのセットアップ時に設定する'sources'の値を取得できる
	---@param self rc.CmpSource[]
	---@return cmp.SourceConfig[]
	__call = function(self)
		---@type cmp.SourceConfig[]
		local t = {}
		for _, source in ipairs(self) do
			---@type cmp.SourceConfig
			local s = { name = source.sourceName }
			if source.option then
				s.option = source.option
			end
			table.insert(t, s)
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