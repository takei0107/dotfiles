---@type LazySpec
return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	---@type fun(self:LazyPlugin, opts:table)|true
	config = function()
		require("mason").setup()
	end,
}
