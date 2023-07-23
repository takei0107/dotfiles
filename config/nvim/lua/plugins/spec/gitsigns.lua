return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost" },
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup({
      on_attach = function(bufnr)
        vim.keymap.set("n", "[g", gitsigns.prev_hunk, { buffer = bufnr })
        vim.keymap.set("n", "]g", gitsigns.next_hunk, { buffer = bufnr })
      end,
    })
  end,
}
