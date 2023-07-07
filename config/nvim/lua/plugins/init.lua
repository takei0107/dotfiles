local function init_lazy()
	-- install lazy.nvim
	-- see: https://github.com/folke/lazy.nvim#-installation
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

local function setup_lazy()
	local lazy = require("lazy")
	-- see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
	lazy.setup("plugins.spec")
end

return {
	initManager = function()
		init_lazy()
	end,
	initSetup = function()
		setup_lazy()
	end
}
