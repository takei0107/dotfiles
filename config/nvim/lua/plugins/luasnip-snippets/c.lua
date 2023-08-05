return require("plugins.luasnip-snippets"):new({
  filetype = "c",
  snippets = function(ls)
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    -- stylua: ignore
    return {
      s({
        trig = "inc",
      }, {
        t("#include<"), i(0, "header"), t(">"),
      }),
      s({
        trig = "def",
      }, {
        t("#define "), i(1, "MACRO"), t(" "), i(0, "VALUE"),
      }),
      s({
        trig = "str",
      }, {
        t("char *"), i(1, "name"), t(' = "'), i(0, "value"), t('";'),
      }),
    }
  end,
})
