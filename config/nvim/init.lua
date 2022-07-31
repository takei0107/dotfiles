local cmd = vim.cmd
local fn = vim.fn
local opt = vim.opt

local vimrc = require('vimrc')

vim.g.loaded_tutor_mode_plugin = true
vim.g.loaded_2html_plugin = true
vim.g.mapleader = " "

opt.encoding = 'utf-8'
opt.fileencodings={'ucs-boom', 'utf-8', 'cp932', 'default'}

cmd [[filetype off]]
cmd [[filetype plugin indent off]]

vim.keymap.set('n', '<F4>', function ()
		vim.cmd("tabnew")
		vimrc:open()
		vim.cmd("normal gg")
end)

-- package
require('packages')

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
opt.backspace = {'indent', 'eol', 'start'}
opt.list = true
opt.updatetime = 555
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.backup = false
opt.completeopt = {'menu', 'menuone', 'noselect'}
local undoDir = fn.stdpath('cache') .. '/undo'
if not(fn.isdirectory(undoDir)) then
	fn.mkdir(undoDir)
end
opt.undodir = undoDir
opt.undofile = true
if fn.has('unix') then
	opt.clipboard:prepend{'unnamedplus', 'unnamed'}
elseif fn.has('mac') then
	opt.clipboard:append{'unnamde'}
end
if fn.has('termguicolors') then
	opt.termguicolors = true
end

vim.keymap.set('n', '<ESC><ESC>', function() cmd('nohlsearch') end, {silent = true})
vim.keymap.set('n', '<F5>', function ()
	vimrc:load()
end, {silent = true})

vim.cmd [[
augroup filetype
	autocmd!
	autocmd FileType java setlocal expandtab shiftwidth=4
	autocmd FileType jsp setlocal expandtab shiftwidth=2
	autocmd FileType go setlocal tabstop=4
	autocmd FileType vim setlocal tabstop=2
	autocmd FileType lua setlocal tabstop=2
	autocmd FileType sh,zsh setlocal tabstop=2
	autocmd FileType toml setlocal tabstop=2
	autocmd FileType diff setlocal tabstop=2
augroup END
]]

-- go organizeImports & format
-- see https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
function OrgImports(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = {only = {"source.organizeImports"}}
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
	vim.lsp.buf.formatting()
end
vim.cmd [[autocmd BufWritePre *.go lua OrgImports(1000)]]

cmd[[filetype plugin indent on]]
