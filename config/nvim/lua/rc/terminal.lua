local terminal_key_prefix = "<C-t>"

-- tabでターミナル開く
vim.keymap.set("n", terminal_key_prefix .. "t", ":tabnew +terminal<CR>", { silent = true })

-- "ctrl-x"でターミナルモード抜ける
vim.keymap.set("t", "<C-x>", [[<C-\><C-n>]])

-- ターミナル起動時にインサートモードでスタートする
local t_ag = vim.api.nvim_create_augroup("terminal", {})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = t_ag,
  pattern = "*",
  callback = function(_)
    vim.cmd("startinsert")
  end,
})
