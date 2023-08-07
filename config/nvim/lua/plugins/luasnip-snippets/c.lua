return require("plugins.luasnip-snippets"):new({
  filetype = "c",
  snippets = function(ls)
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    -- local sn = ls.snippet_node
    -- local isn = ls.indent_snippet_node
    -- stylua: ignore
    return {
      -- '#include<{}>'
      s({
        trig = "inc",
      }, {
        t("#include<"), i(0, "header"), t(">"),
      }),
      -- '#define {} {}'
      s({
        trig = "def",
      }, {
        t("#define "), i(1, "MACRO"), t(" "), i(0, "VALUE"),
      }),
      -- 'car *{} = {};'
      s({
        trig = "str",
      }, {
        t("char *"), i(1, "name"), t(' = "'), i(0, "value"), t('";'),
      }),
      -- if文
      s({
        trig = "if",
      }, {
        t("if("), i(1, "cond"), t({") {", ""}),
        t("\t"), i(0, "body"),
        t({"", "}"})
      }),
      -- while文
      s({
        trig = "while",
      }, {
        t("while("), i(1, "cond"), t({") {", ""}),
        t("\t"), i(0, "body"),
        t({"", "}"})
      }),
      -- for文
      s({
        trig = "for",
      }, {
        t("for("), i(1, "init"), t("; "), i(2, "test"), t("; "), i(3, "post"), t({") {", ""}),
        t("\t"), i(0, "body"),
        t({"", "}"})
      })
    }
  end,
})
