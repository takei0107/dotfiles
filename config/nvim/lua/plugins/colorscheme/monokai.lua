local M = require("plugins.colorscheme.colorscheme").new({
	repo = "tanvirtin/monokai.nvim",
	schemeName = "monokai",
	lazyPriority = 1000,
	config = function()
		require("monokai").setup({})
	end,
	transparent_enable = true,
	skipSetup = true,
})

return M
