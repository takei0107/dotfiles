---@class rc.LspSetting
---@field ls_name string lspconfigで使われるLS名
---@field mason_ls_name string masonで使われるLS名
---@field enable boolean|nil lspサーバーを有効化する 明示的にfalseを設定しない限り有効
---@field force_install boolean|nil lspサーバーの強制インストール trueの時のみ強制する
---@field lspconfig_handler fun(lspconfig: any)|nil ":h mason-lspconfig.setup_handlers()"

---@type rc.LspSetting[]
local settings = {
	-- 各LSの設定を書いていく
	{
		ls_name = "lua_ls",
		mason_ls_name = "lua_ls",
		enable = true,
		force_install = true,
		lspconfig_handler = function(lspconfig)
			lspconfig.setup({})
		end
	}
}

-- LS名※から設定を逆引き
-- ※lspconfigで使われるLS名
setmetatable(settings, {
	---@param self rc.LspSetting[]
	---@param server_name string
	---@return rc.LspSetting|nil
	__index = function (self, server_name)
		for _, setting in ipairs(self) do
			if server_name == setting.ls_name then
				return setting
			end
			return nil
		end
	end
})

return settings
