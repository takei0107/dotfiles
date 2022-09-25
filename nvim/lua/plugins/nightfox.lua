return function()
	require('nightfox').setup({
		options = {
			dim_inactive = true,
			terminal_colors = true,
			modules = {
				neotree = true,
			},
			transparent = true,
		}
	})
	vim.cmd('colorscheme nordfox')
	vim.cmd('highlight TabLineFill guibg=NONE')
end
