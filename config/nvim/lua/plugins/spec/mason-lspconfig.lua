local lsp_settings = require("lsp.settings") or {}

---@param setting rc.LspSetting
---@return boolean
local function is_setting_enable(setting)
	-- 明示的にfalseを設定しない限り有効
	return (setting.enable ~= false) or false
end

---@return string[]
local function ensure_installed()
	---@type string[]
	local r = {}
	for _, setting in ipairs(lsp_settings) do
		if is_setting_enable(setting) and setting.force_install then
			if setting.ls_name then
				table.insert(r, setting.ls_name)
			end
		end
	end
	return r
end

---@param server_name string
local function invoke_lspconfig_handler(server_name)
	local setting = lsp_settings[server_name]
	if setting and is_setting_enable(setting) then
		if setting.lspconfig_handler then
			setting.lspconfig_handler(require("lspconfig")[server_name])
		end
	end
end

---@type LazySpec
return {
	"williamboman/mason-lspconfig.nvim",
	---@type LazySpec[]
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	---@type fun(self:LazyPlugin, opts:table)|true
	config = function()
		require("mason-lspconfig").setup({
			-- see: ":h mason-lspconfig-default-settings"
			ensure_installed = ensure_installed(),
		})

		-- see: ":h mason-lspconfig.setup_handlers()"
		require("mason-lspconfig").setup_handlers({
			function(server_name)
				print(("[debug] LSP server:%s is ready for setup."):format(server_name))
				invoke_lspconfig_handler(server_name)
			end,
		})

		require("lsp.keymap").register()
	end,
}
