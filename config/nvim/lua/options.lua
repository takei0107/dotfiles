local opt = vim.opt
local fn = vim.fn

opt.encoding = 'utf-8'
opt.fileencodings = { 'ucs-boom', 'utf-8', 'cp932', 'default' }
opt.hidden = true
opt.helplang = 'ja'
opt.smartindent = true
opt.shiftwidth = 0
opt.softtabstop = -1
opt.number = true
opt.belloff = 'all'
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.laststatus = 2
opt.wildmenu = true
opt.showcmd = true
opt.display = 'truncate'
opt.backspace = { 'indent', 'eol', 'start' }
opt.list = true
opt.updatetime = 555
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.backup = false
opt.completeopt = { 'menu', 'menuone', 'noselect' }
local undoDir = fn.stdpath('cache') .. '/undo'
if not (fn.isdirectory(undoDir)) then
	fn.mkdir(undoDir)
end
opt.undodir = undoDir
opt.undofile = true
if fn.has('unix') then
	opt.clipboard:prepend { 'unnamedplus', 'unnamed' }
elseif fn.has('mac') then
	opt.clipboard:append { 'unnamde' }
end
if fn.has('termguicolors') then
	opt.termguicolors = true
end
