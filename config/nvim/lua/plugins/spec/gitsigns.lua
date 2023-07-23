return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost" },
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup({})
    vim.keymap.set("n", "[g", gitsigns.prev_hunk)
    vim.keymap.set("n", "]g", gitsigns.next_hunk)
  end,
}
