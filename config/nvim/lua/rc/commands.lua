-- ":Of オプション名" で設定値表示
vim.cmd([[command! -nargs=1 -complete=option Of execute("echo &"..expand("<args>"))]])

-- helpをvsplitで開く
vim.cmd("command! -nargs=1 -complete=help Vhelp vertical help <args>")

-- lua
local lua_ag_id = vim.api.nvim_create_augroup("MyLuaCommand", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = lua_ag_id,
  pattern = { "lua" },
  callback = function()
    -- luaの現在行をチャンクとして実行
    vim.api.nvim_buf_create_user_command(0, "LuaExprLine", ".luado assert(loadstring(line))()", { nargs = 0 })
  end,
})
