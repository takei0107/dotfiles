local settings = {
	-- 各LSの設定を書いていく
	{
		-- lspconfigで使われるLS名
		ls_name = "lua_ls",
		-- masonで使われるLS名
		mason_ls_name = "lua_ls",
		-- 明示的にfalseを設定しない限り有効
		enable = true,
		force_install = true,
		-- see: ":h mason-lspconfig.setup_handlers()"
		lspconfig_handler = function(lspconfig)
			lspconfig.setup({})
		end
	}
}

-- LS名※から設定を逆引き
-- ※lspconfigで使われるLS名
setmetatable(settings, {
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
