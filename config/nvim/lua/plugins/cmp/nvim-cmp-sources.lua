local sources = {
	-- name: lazy.nvimで使うリポジトリ名
	-- sourceName: nvim-cmpのソース名
	-- option: nvim-cmpの各ソースのオプション
	-- format: ":h cmp-config.formatting.format"
	{
		name = "hrsh7th/cmp-buffer" ,
		sourceName = "buffer",
		option = {
		},
		format = function(vim_item)
			vim_item.kind = "buffer"
			return vim_item
		end
	},
}

setmetatable(sources, {
	__call = function(self)
		local t = {}
		for _, source in ipairs(self) do
			local s = {name = source.sourceName}
			if source.option then
				s.option = option
			end
			table.insert(t, s)
		end
		return t
	end,
	__index = function(self, sourceName)
		for _, source in ipairs(self) do
			if source.sourceName == sourceName then
				return source
			end
		end
		return nil
	end
})

return sources
