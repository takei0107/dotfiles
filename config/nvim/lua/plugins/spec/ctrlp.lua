return {
  "ctrlpvim/ctrlp.vim",
  init = function()
    -- ctrlp settings
    vim.g.ctrlp_map = "<leader>ff"
    vim.g.ctrlp_working_path_mode = "w"
    vim.g.ctrlp_cache_dir = vim.fn.stdpath("cache") .. "/ctrlp"
    vim.g.ctrlp_reuse_window = [[help\|fern]]
    vim.g.ctrlp_show_hidden = 1
  end,
  config = function()
    -- ctrlp key mappings
    -- initで設定するとロード時にマッピングが消えてしまったのでここでマッピング作成
    vim.keymap.set("n", "<leader>bb", "<cmd>CtrlPBuffer<cr>")
    vim.keymap.set("n", "<leader>mm", "<cmd>CtrlPMRU<cr>")
  end,
  cmd = { "Ctrlp", "CtrlPBuffer", "CtrlPMRU" },
  keys = { "<leader>ff", "<leader>bb", "<leader>mm" },
}
