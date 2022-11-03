local undoDir = vim.fn.stdpath('cache') .. '/undo'

-- :set=
local set_opts = {
	encoding = 'utf-8',
	fileencodings = { 'ucs-boom', 'utf-8', 'cp932', 'default' },
	hidden = true,
	helplang = 'ja',
	smartindent = true,
	shiftwidth = 0,
	softtabstop = -1,
	number = true,
	belloff = 'all',
	hlsearch = true,
	incsearch = true,
	ignorecase = true,
	smartcase = true,
	cursorline = true,
	laststatus = 2,
	wildmenu = true,
	showcmd = true,
	display = 'truncate',
	backspace = { 'indent', 'eol', 'start' },
	list = true,
	updatetime = 555,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	backup = false,
	completeopt = { 'menu', 'menuone', 'noselect' },
}
set_opts.undodir = {
	undoDir,
	prefook = function()
		require("lib.util").mkdir_if_not_exist(undoDir, "p")
	end,
	condition = function()
		return vim.fn.isdirectory(undoDir)
	end
}
set_opts.undofile = {
	true,
	condition = function()
		return vim.fn.isdirectory(undoDir)
	end
}
set_opts.termguicolors = {
	true,
	condition = function()
		return vim.fn.has('termguicolors')
	end
}

-- :set^=
local prepend_opts = {}
prepend_opts.clipboard = {
	{ 'unnamedplus', 'unnamed' },
	condition = function()
		return vim.fn.has('unix')
	end
}

-- :set+=
local append_opts = {}
append_opts.clipboard = {
	{ 'unnamed' },
	condition = function()
		return vim.fn.has('mac')
	end
}

local function configure(opts_config, setfn)
	for opt_name, v in pairs(opts_config) do
		local opt_value = v
		local condition = nil
		local prefook = nil
		if type(v) == "table" and (v["condition"] ~= nil or v["prefook"] ~= nil) then
			if v["condition"] ~= nil then
				condition = v["condition"]
			end
			if v["prefook"] ~= nil then
				prefook = v["prefook"]
			end
			opt_value = v[1]
		end
		setfn(opt_name, opt_value, condition, prefook)
	end
end

local o = require('lib.option')
local opts_configs = {
	{
		opts_config = set_opts,
		setfn = o.setopt
	},
	{
		opts_config = prepend_opts,
		setfn = o.prependopt
	},
	{
		opts_config = append_opts,
		setfn = o.appendopt
	}
}
for _, config in pairs(opts_configs) do
	configure(config.opts_config, config.setfn)
end
