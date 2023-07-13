return {
	"itchyny/lightline.vim",
	init = function()
		vim.g.lightline = {
			tabline = {
				right = {},
			},
			colorscheme = "wombat",
		}
	end,
	config = function()
		if vim.g.use_sonokai then
			local lightline = vim.g.lightline
			lightline.colorscheme = "sonokai"
			vim.g.lightline = lightline
			vim.cmd("call lightline#init()")
			vim.cmd("call lightline#colorscheme()")
		end
	end,
}
