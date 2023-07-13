return {
	"itchyny/lightline.vim",
	init = function()
		local colorscheme = vim.g.use_sonokai and "sonokai" or "wombat"
		vim.g.lightline = {
			tabline = {
				right = {},
			},
			colorscheme = colorscheme,
		}
	end,
}
