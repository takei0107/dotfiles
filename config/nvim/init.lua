local cmd = vim.cmd
vim.g.loaded_tutor_mode_plugin = true
vim.g.loaded_2html_plugin = true
vim.g.loaded_mathit = true
vim.g.mapleader = " "

cmd [[filetype off]]
cmd [[filetype plugin indent off]]

require('options')
require('keymaps')
require('packages')
require('filetype')
require('diagnostics')

cmd [[
au TermOpen * startinsert
]]

-- go organizeImports & format
-- see https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
function OrgImports(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
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

cmd [[filetype plugin indent on]]
