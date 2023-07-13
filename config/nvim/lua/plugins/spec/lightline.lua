return {
	"itchyny/lightline.vim",
	init = function()
		vim.g.lightline = {
			tabline = {
				right = {},
			},
			colorscheme = "wombat",
		}
		vim.g.loaded_lightline = 1
	end,
	config = function()
		-- sonokaiテーマを反映させたいのでロード後にプラグイン読み込みする
		if vim.g.use_sonokai then
			-- :h lua-vim-variables
			local lightline = vim.g.lightline
			lightline.colorscheme = "sonokai"
			vim.g.lightline = lightline
		end
		vim.g.loaded_lightline = 0
		vim.cmd("runtime! lightline")
	end,
}
