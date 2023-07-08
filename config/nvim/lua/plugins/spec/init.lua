return {
	---@type LazySpec
	require("plugins.colorscheme"):toLazySpec() or {},
	{ "nvim-lua/plenary.nvim", lazy = true },
}
