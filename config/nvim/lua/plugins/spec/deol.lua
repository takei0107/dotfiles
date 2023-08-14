local floatUtil = require("util.float")

return {
  "Shougo/deol.nvim",
  --enabled = false,
  keys = { "<C-t>" },
  cmd = { "Deol", "DeolEdit" },
  init = function()
    local shell = vim.fn.fnamemodify(vim.o.shell, ":p:t")
    if shell == "zsh" then
      vim.g["deol#prompt_pattern"] = "^.*[❯❮] " -- 対話シェルで使っているプロンプト文字列
    end
    vim.g["deol#floating_border"] = "single"
    local floatConfig = floatUtil.make_float_config({
      row = 1,
    })
    local cmd = "<cmd>Deol -split=floating -toggle -winheight=%d -winrow=%d -winwidth=%d -wincol=%d<CR>"
    vim.keymap.set("n", "<C-t>f", cmd:format(floatConfig.height, floatConfig.row, floatConfig.width, floatConfig.col))
  end,
}
