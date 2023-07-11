---@class rc.LspSetting
---@field ls_name string lspconfigで使われるLS名
---@field mason_ls_name string masonで使われるLS名
---@field ft string|string[] mason-lspconfiをlazyでロードするファイルタイプ
---@field enable boolean|nil lspサーバーを有効化する 明示的にfalseを設定しない限り有効
---@field force_install boolean|nil lspサーバーの強制インストール trueの時のみ強制する
---@field lspconfig_handler fun(lspconfig: any)|nil ":h mason-lspconfig.setup_handlers()"

---@type rc.LspSetting[]
local settings = {
	-- 各LSの設定を書いていく
	{
		ls_name = "lua_ls",
		mason_ls_name = "lua_ls",
		ft = { "lua" },
		enable = true,
		force_install = true,
		lspconfig_handler = function(lspconfig)
			lspconfig.setup({})
		end,
	},
	{
		ls_name = "bashls",
		mason_ls_name = "bash-language-server",
		ft = { "bash", "sh" },
		enable = true,
		force_install = true,
		lspconfig_handler = function(lspconfig)
			lspconfig.setup({})
		end,
	},
}

setmetatable(settings, {
	---@param self rc.LspSetting[]
	---@param server_name string lspconfigで使われるLS名
	---@return rc.LspSetting|nil
	-- LS名から設定を逆引き
	__index = function(self, server_name)
		for _, setting in ipairs(self) do
			if server_name == setting.ls_name then
				return setting
			end
		end
		return nil
	end,
})

return settings
