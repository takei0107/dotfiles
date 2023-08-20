---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    vim.cmd.TSUpdate()
  end,
  ft = { "lua" },
  ---@type fun(self:LazyPlugin, opts:table)|true
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua" },
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = true,
      },
    })
  end,
}
