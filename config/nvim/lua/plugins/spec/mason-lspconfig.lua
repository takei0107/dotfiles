local lsp_settings = require("lsp.settings") or {}

local function ensure_installed()
	local r = {}
	for _, setting in ipairs(lsp_settings) do
		if setting.enable and setting.force_install then
			if setting.mason_ls_name then
				table.insert(r, setting.mason_ls_name)
			end
		end
	end
	return r
end

local function invoke_lspconfig_handler(server_name)
	local setting = lsp_settings[server_name]
	if setting and ((setting.enable ~= false) or false) then
		if setting.lspconfig_handler then
			setting.lspconfig_handler(require("lspconfig")[server_name])
		end
	end
end

return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig"
	},
	config = function()
		require("mason-lspconfig").setup({
			-- see: ":h mason-lspconfig-default-settings"
			ensure_installed = ensure_installed()
		})

		-- see: ":h mason-lspconfig.setup_handlers()"
		require("mason-lspconfig").setup_handlers {
			function(server_name)
				invoke_lspconfig_handler(server_name)
			end,
		}
	end
}
