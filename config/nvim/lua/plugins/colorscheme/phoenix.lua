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

    -- lazy.nvim
    vim.cmd.highlight({ args = { "link", "LazyProp", "CursorLine" }, bang = true })

    -- ctrlp
    vim.cmd.highlight({ args = { "link", "CtrlPMatch", "SpecialKey" }, bang = true })

    -- vimdoc
    vim.cmd.highlight({ args = { "link", "@text.reference.vimdoc", "WarningMsg" }, bang = true })
    vim.cmd.highlight({ args = { "link", "@string.special.vimdoc", "MoreMsg" }, bang = true })
    vim.cmd.highlight({ args = { "link", "@parameter.vimdoc", "SpellCap" }, bang = true })
  end,
})
