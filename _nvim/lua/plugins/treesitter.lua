return function()
	require('nvim-treesitter.configs').setup({
		auto_install = true,
		ignore_install = {
			'help'
		},
		highlight = {
			enable = true,
			disable = {
				"help"
			},
		},
	})
end
