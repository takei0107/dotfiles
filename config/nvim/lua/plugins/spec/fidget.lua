return {
  "j-hui/fidget.nvim",
  tag = "legacy",
  --event = "LspAttach",
  lazy = true,
  config = function()
    require("fidget").setup({})
  end,
}
