local set = vim.opt

set.belloff = "all"
set.number = true
set.list = true
set.relativenumber = true
set.scrolloff = 5
set.ignorecase = true
set.smartcase = true
set.smartindent = true
set.smarttab = true
set.undofile = true
set.swapfile = false
set.splitright = true
set.splitbelow = true
set.cursorline = true
set.cursorlineopt = { "screenline" }
set.virtualedit = "block"
set.laststatus = 2
set.signcolumn = "yes"
set.cmdheight = 1
set.completeopt = "menu"
set.matchpairs:append("<:>")
set.nrformats:append("unsigned")
set.path:append(vim.env.PWD .. "/**")
