local M = {}

M.configure = function()
	local options = {
		dim_inactive = true,
		terminal_colors = true,
		modules = {
			neotree = true,
		},
		transparent = true,
	}

	require('nightfox').setup({
		options = options
	})

	vim.cmd('colorscheme nordfox')
	vim.cmd('highlight TabLineFill guibg=NONE')
end

return M
