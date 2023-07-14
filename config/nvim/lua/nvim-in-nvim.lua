local M = {}

--- nvim in nvimでの起動
---@param util rc.Util
M.init = function(util)
  ---@param initializer rc.PluginsInitializer
  local _, err = util.safeRequire("plugins", function(initializer)
    initializer.initManager()
    initializer.initSetupInNvim()
  end)
  if err then
    print("safeRequire() failed. error: " .. err)
  end
end

return M
