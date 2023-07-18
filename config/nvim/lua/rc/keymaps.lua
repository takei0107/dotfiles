local keymap = vim.keymap

-- see ":h map-table"
----------------------------------------------------------------------
--          Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
-- Command        +------+-----+-----+-----+-----+-----+------+------+
-- [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
-- n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
-- [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
-- i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
-- c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
-- v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
-- x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
-- s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
-- o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
-- t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
-- l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
----------------------------------------------------------------------

vim.g.mapleader = " "

-- same as <C-L>
-- vim.keymap.set("n", "<ESC><ESC>", "<cmd>nohlsearch<CR><ESC>", { silent = true })

-- '*','#'による検索で次の一致に自動的に飛ばないようにする
-- see ':h restore-position'
keymap.set("n", "*", "msHmt`s*'tzt`s")
keymap.set("n", "#", "msHmt`s#'tzt`s")

keymap.set("x", "$", "g_")

-- ビジュアルの'p'で無名レジスタ更新しない
keymap.set("x", "p", "P")

keymap.set({ "o", "x" }, 'a"', '2i"')
keymap.set({ "o", "x" }, "a'", "2i'")
keymap.set({ "o", "x" }, "a`", "2i`")

keymap.set({ "n", "x" }, "x", '"_x')
keymap.set({ "n", "x" }, "X", '"_X')
keymap.set({ "n", "x" }, "s", '"_s')
keymap.set({ "n", "x" }, "S", '"_S')

-- reload vimrc
keymap.set("n", "<F5>", function()
  local vimrc = vim.env.MYVIMRC
  vim.cmd("luafile " .. vimrc)
  print(string.format("%s reloaded", vimrc))
end)

-- popup-menuが出ているときに<CR>で選択する
keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-Y>"
  else
    return "<CR>"
  end
end, {
  expr = true,
})
