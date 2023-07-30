---@type table<string, rc.LSConfig>
local settings = {
  lua_ls = require("lsp.ls-configs.lua_ls"),
  bashls = require("lsp.ls-configs.bash-language-server"),
  vimls = require("lsp.ls-configs.vimls"),
}

return settings
