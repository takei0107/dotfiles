---@return string[]
local function lua_library()
  local libraries = { vim.env.VIMRUNTIME .. "/lua" }
  local plugin_libraries = require("plugins.lua-libraries") or {}
  for _, lib in ipairs(plugin_libraries) do
    table.insert(libraries, lib)
  end
  return libraries
end

return require("lsp.ls-configs"):new({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
        disable = {
          "duplicate-set-field",
          "duplicate-doc-alias",
          "duplicate-doc-field",
          "duplicate-doc-param",
        },
        libraryFiles = "Disable",
      },
      workspace = {
        library = lua_library(),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
