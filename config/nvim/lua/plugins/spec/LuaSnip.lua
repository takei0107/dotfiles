return {
  "L3MON4D3/LuaSnip",
  version = "1.*",
  event = "InsertEnter",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")

    vim.keymap.set("i", "<tab>", function()
      if ls.locally_jumpable(1) then
        ls.jump(1)
      else
        vim.api.nvim_feedkeys(termcodes("<tab>"), "n", false)
      end
    end)
    vim.keymap.set("i", "<s-tab>", function()
      if ls.locally_jumpable(-1) then
        ls.jump(-1)
      else
        vim.api.nvim_feedkeys(termcodes("<s-tab>"), "n", false)
      end
    end)

    -- filetype snippets
    require("plugins.luasnip-snippets.c"):add_snippets()
  end,
}
