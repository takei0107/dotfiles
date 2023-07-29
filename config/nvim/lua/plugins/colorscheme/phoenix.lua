return require("plugins.colorscheme.colorscheme").new({
  repo = "widatama/vim-phoenix",
  schemeName = "phoenix",
  lazy = true,
  init = function()
    vim.g.phoenix_bg = "normal"
    vim.g.phoenix_acc = "red"
  end,
})
