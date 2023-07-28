---@module "util.init"
local util = require("util")

-- gitのcommitメッセージで開いた場合
--- @return boolean
local function isOnGitCommitMsg()
  for _, arg in ipairs(vim.v.argv) do
    if string.match(arg, "COMMIT_EDITMSG") then
      return true
    end
  end
  return false
end

-- lazy.nvimをmini modeで実行するかを判定する
---@return boolean
local function isUseMiniMode()
  return isOnGitCommitMsg()
end

-- プラグイン読み込み
local function load_plugins()
  ---@type boolean, rc.Util|string
  ---@param initializer rc.PluginsInitializer
  local _, err = util.safeRequire("plugins", function(initializer)
    initializer.initManager()
    initializer.initSetup(isUseMiniMode())
    initializer.initColorScheme()
  end)
  if err then
    print("safeRequire() failed. error: " .. err)
  end
end

--
load_plugins()
