-- install lazy.nvim
---@see https://github.com/folke/lazy.nvim#-installation
local function init_lazy()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
end

-- setup lazy.nvim
---@see https://github.com/folke/lazy.nvim#-structuring-your-plugins
local function setup_lazy()
	local lazy = require("lazy")
	if not lazy then
		error("lazy didn't loaded.")
	end
	lazy.setup("plugins.spec", {})
end

-- setup colorscheme
local function setup_colorscheme()
	local colorscheme = require("plugins.colorscheme")
	if not colorscheme.skipSetup then
		if colorscheme.setup then
			colorscheme:setup()
		end
	end
	if colorscheme.transparent_enable then
		colorscheme.transparent()
	end
end

return {
	initManager = function()
		init_lazy()
	end,
	initSetup = function()
		setup_lazy()
		setup_colorscheme()
	end
}
