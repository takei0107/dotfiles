return require("plugins.colorscheme.colorscheme").new({
  repo = "widatama/vim-phoenix",
  schemeName = "phoenix",
  lazy = true,
  init = function()
    vim.g.phoenix_bg = "normal"
    vim.g.phoenix_acc = "red"
  end,
  adjustor = function()
    vim.cmd.highlight({ args = { "Identifier", "guifg=efefef" }, bang = true })
    vim.cmd.highlight({ args = { "link", "CtrlPMatch", "SpecialKey" } })
    vim.cmd.highlight({ args = { "link", "LazyProp", "CursorLine" } })
  end,
})
