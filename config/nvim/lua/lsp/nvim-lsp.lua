local mapping = require('lib.mapping')

local on_attach = function(client, bufnr)
	local lsp_buf = vim.lsp.buf
	--mapping.noremap('n'):buffer(bufnr):silent():bind('gd', lsp_buf.definition)
	--mapping.noremap('n'):buffer(bufnr):silent():bind('gi', lsp_buf.implementation)
	--mapping.noremap('n'):buffer(bufnr):silent():bind('gr', lsp_buf.references)
	mapping.noremap('n'):buffer(bufnr):silent():bind('<leader>rn', lsp_buf.rename)
	mapping.noremap('n'):buffer(bufnr):silent():bind('K', lsp_buf.hover)
	mapping.noremap('n'):buffer(bufnr):silent():bind('<leader>ca', lsp_buf.code_action)

	-- telescope builtin lsp functions
	local telescope_builtin = require('telescope.builtin')
	mapping.noremap('n'):buffer(bufnr):silent():bind('gd', telescope_builtin.lsp_definitions)
	mapping.noremap('n'):buffer(bufnr):silent():bind('gi', telescope_builtin.lsp_implementations)
	mapping.noremap('n'):buffer(bufnr):silent():bind('gr', telescope_builtin.lsp_references)
	mapping.noremap('n'):buffer(bufnr):silent():bind('<leader>ds', telescope_builtin.diagnostics)

	-- formatting
	mapping.noremap('n'):buffer(bufnr):silent():bind('<leader><C-f>', lsp_buf.formatting)

	vim.cmd [[
    autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
	]]
end

-- よくわかっていない
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local default_config = {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- lsp setup
require('mason').setup()
require('mason-lspconfig').setup()
require('mason-lspconfig').setup_handlers({

	-- [[ default lsp config ]]
	function(server_name)
		require('lspconfig')[server_name].setup {
			on_attach = default_config.on_attach,
			capabilities = default_config.capabilities,
		}
	end,

	-- [[ lua lsp config ]]
	["sumneko_lua"] = function()
		require("lspconfig")["sumneko_lua"].setup {
			on_attach = default_config.on_attach,
			capabilities = default_config.capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { 'vim' }, -- vimのwarning抑止
					},
				}
			},
		}
	end
})
