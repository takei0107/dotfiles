require("skip_load")

vim.api.nvim_command("filetype off")
vim.api.nvim_command("filetype plugin indent off")

-- leaderキー
vim.g.mapleader = " "

require("options")
require("keymaps")
require("terminal")
require("packages")
require("filetype")
require("diagnostics")

vim.api.nvim_command("filetype plugin indent on")
