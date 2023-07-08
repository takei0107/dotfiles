return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig"
	},
	config = function()
		require("mason-lspconfig").setup({
			-- see: ":h mason-lspconfig-default-settings"
			ensure_installed = {"lua_ls"}
		})
		-- see: "mason-lspconfig.setup_handlers()"
		require("mason-lspconfig").setup_handlers {
			["lua_ls"] = function()
				require("lspconfig").lua_ls.setup({})
			end
		}
	end
}
