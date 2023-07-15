return {
  "lambdalisue/fern.vim",
  lazy = true,
  init = function()
    local fern_prefix = "<C-k>"
    vim.keymap.set("n", fern_prefix .. "f", "<Cmd>Fern . -reveal=% -opener=edit<CR>")
  end,
  cmd = { "Fern", "FernReveal" },
}
