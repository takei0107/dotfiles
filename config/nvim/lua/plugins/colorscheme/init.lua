local colorscheme = {
		repo = "jacoborus/tender.vim",
		schemeName = "tender",

		highlight_handlers = {
			["tender"] = function()
				vim.cmd("hi Normal ctermbg=none")
				vim.cmd("hi LineNr ctermfg=none")
				vim.cmd("hi SignColumn ctermbg=none")
				vim.cmd("hi SignColumn ctermfg=none")
				vim.cmd("hi SignColumn guibg=none")
			end
		}
}

function colorscheme:toLazySpec()
	return {
		[1] = self.repo,
		priority = 1000,
		-- auto load when doing 'colorscheme {scheme}'
		lazy = true
	}
end

return colorscheme
