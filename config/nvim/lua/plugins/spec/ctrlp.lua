return {
  "ctrlpvim/ctrlp.vim",
  init = function()
    vim.g.ctrlp_map = "<leader>ff"
    vim.g.ctrlp_working_path_mode = "w"
    vim.g.ctrlp_cache_dir = vim.fn.stdpath("cache") .. "/ctrlp"
    vim.g.ctrlp_show_hidden = 1

    vim.keymap.set("n", "<leader>bb", "<cmd>CtrlPBuffer<cr>")
    vim.keymap.set("n", "<leader>mm", "<cmd>CtrlPMRU<cr>")
  end,
}
