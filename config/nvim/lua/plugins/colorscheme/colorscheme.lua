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

---@class rc.colorscheme
---@field repo string lazy.nvimで使うリポジトリ名
---@field schemeName string カラースキーム名
---@field lazyPriority integer|nil lazyの優先度 lazyのヘルプの'COLORSCHEMES'参照
---@field lazy boolean
---@field config fun(self:LazyPlugin, opts:table)|true|nil
---@field skipSetup boolean trueの時、setupメソッドをスキップする
---@field transparent_enable boolean 背景透過させるかどうか
---
-- 'lazy'がtrueかつ、'skipSetup'がtrue以外の時
-- ':colorscheme {schemeName}'がsetupメソッドで実行されるタイミングで
-- 対象のカラースキームのプラグインがlazyによってロードされる。
--
-- カラースキームの中にはプラグイン内でカラースキームの指定をしている場合があるので
-- その場合は、'skipSetup'をtrueに設定し、'config'を設定した上で、
-- lazyの読み込み時にプラグインが提供している初期化手順を実行する。
--
local colorscheme = {}

---@param config rc.colorscheme
---@return rc.colorscheme
colorscheme.new = function(config)
	return setmetatable({
		repo = config.repo,
		schemeName = config.schemeName,
		lazyPriority = config.lazyPriority,
		lazy = config.lazy or false,
		config = config.config,
		skipSetup = config.skipSetup or false,
		transparent_enable = config.transparent_enable or false,
	}, {
		__index = colorscheme,
	})
end

function colorscheme:setup()
	vim.cmd("syntax enable")
	vim.opt.termguicolors = true
	vim.cmd(string.format("colorscheme %s", self.schemeName))
end

---@return LazySpec
function colorscheme:toLazySpec()
	---@type LazySpec
	return {
		[1] = self.repo,
		---@type integer|nil
		priority = self.lazyPriority,
		lazy = self.lazy,
		---@type fun(self:LazyPlugin, opts:table)|true|nil
		config = self.config,
	}
end

function colorscheme.transparent()
	ui_tranparent()
end

return colorscheme
