local M = require("plugins.colorscheme.colorscheme").new({
  repo = "tanvirtin/monokai.nvim",
  schemeName = "monokai_soda",
  lazyPriority = 1000,
  config = function()
    require("monokai").setup({
      palette = require("monokai").soda,
      italics = false,
    })
  end,
})

return M
