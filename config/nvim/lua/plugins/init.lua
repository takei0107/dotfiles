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
	require("lazy").setup("plugins.spec", {})
end

-- setup lazy.nvim for mini mode
-- 必要最低限のプラグインのみロードする
local function setup_lazy_minimode()
	local mini_mode_specs = {
		require("plugins.spec"),
		require("plugins.spec.LuaSnip"),
		require("plugins.spec.lightline"),
		require("plugins.spec.nvim-cmp"),
	}
	require("lazy").setup(mini_mode_specs, {
		root = vim.fn.stdpath("data") .. "/lazy-mini-mode",
		lockfile = vim.fn.stdpath("config") .. "/lazy-mini-mode-lock.json",
		install = {
			missing = true,
		},
		change_detection = {
			enabled = false,
			notify = false,
		},
		readme = {
			enabled = false,
		},
		state = vim.fn.stdpath("state") .. "/lazy-mini-mode/state.json",
	})
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

---@class rc.PluginsInitializer
local M = {
	-- プラグインマネージャーを初期化する
	initManager = function()
		init_lazy()
	end,
	-- プラグインのセットアップする
	-- `isMiniMode`がtrueの場合にはミニモードとして最低限のプラグインで起動する。
	---@param isMiniMode boolean mini mode 起動フラグ
	initSetup = function(isMiniMode)
		if isMiniMode then
			setup_lazy_minimode()
		else
			setup_lazy()
		end
		setup_colorscheme()
	end,
}

return M
