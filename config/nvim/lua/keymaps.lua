local cmd = vim.cmd

local mappings = require('lib.mapping')

-- nmap
mappings.noremap('n'):silent():bind('<Esc><Esc>', function ()
	vim.cmd('nohlsearch')
end)

mappings.noremap('n'):silent():bind('<F5>', function ()
	require('vimrc'):load()
end)

mappings.noremap('n'):silent():bind('<F4>', function ()
	cmd("tabnew")
	require('vimrc'):open()
  cmd("normal gg")
end)

mappings.noremap('n'):silent():bind('<Up>', '<C-w>k')
mappings.noremap('n'):silent():bind('<Down>', '<C-w>j')
mappings.noremap('n'):silent():bind('<Right>', '<C-w>l')
mappings.noremap('n'):silent():bind('<Left>', '<C-w>h')

-- tmap
mappings.noremap('t'):silent():bind('<Esc>', [[<C-\><C-n>]])
