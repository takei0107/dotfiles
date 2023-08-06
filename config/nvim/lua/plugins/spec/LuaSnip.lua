return {
  "L3MON4D3/LuaSnip",
  version = "2.*",
  event = "InsertEnter",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")

    -- keymaps
    vim.keymap.set("i", "<tab>", function()
      if ls.locally_jumpable(1) then
        return "<Plug>luasnip-jump-next"
      else
        return "<tab>"
      end
    end, {
      expr = true,
    })
    vim.keymap.set("i", "<s-tab>", function()
      if ls.locally_jumpable(-1) then
        return "<Plug>luasnip-jump-prev"
      else
        return "<s-tab>"
      end
    end, {
      expr = true,
    })

    -- filetype snippets
    require("plugins.luasnip-snippets.c"):add_snippets()
  end,
}
