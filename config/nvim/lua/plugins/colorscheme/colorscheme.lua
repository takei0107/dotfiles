local function ui_tranparent()
	if vim.opt.termguicolors:get() then
		vim.cmd("hi Normal guibg=none")
		vim.cmd("hi LineNr guifg=none")
		vim.cmd("hi LineNr guibg=none")
		vim.cmd("hi SignColumn guibg=none")
		vim.cmd("hi SignColumn guifg=none")
	else
		vim.cmd("hi Normal ctermbg=none")
		vim.cmd("hi LineNr ctermfg=none")
		vim.cmd("hi SignColumn ctermbg=none")
		vim.cmd("hi SignColumn ctermfg=none")
	end
end

local colorscheme = {}

colorscheme.new = function(config)
	return setmetatable({
		repo = config.repo,
		schemeName = config.schemeName,
		lazyPriority = config.lazyPriority,
		lazy = config.lazy or false,
		config = config.config,
		skipSetup = config.skipSetup or false,
		transparent_enable = config.transparent_enable or false
	}, {
		__index = colorscheme
	})
end

function colorscheme:setup()
	vim.cmd("syntax enable")
	vim.opt.termguicolors = true
	vim.cmd(string.format("colorscheme %s", self.schemeName))
end

function colorscheme:toLazySpec()
	return {
		[1] = self.repo,
		priority = self.lazyPriority,
		-- auto load when doing 'colorscheme {scheme}'
		lazy = self.lazy,
		config = self.config
	}
end

function colorscheme.transparent()
	ui_tranparent()
end

return colorscheme
