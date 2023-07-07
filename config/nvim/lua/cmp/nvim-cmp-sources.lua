local sources = {
	-- name: lazy.nvimで使うリポジトリ名
	-- sourceName: nvim-cmpのソース名
	{ name = "hrsh7th/cmp-buffer" , sourceName = "buffer"},
}

setmetatable(sources, {
	__call = function(self)
		local t = {}
		for _, source in ipairs(self) do
			local s = {name = source.sourceName}
			table.insert(t, s)
		end
		return t
	end
})

return sources
