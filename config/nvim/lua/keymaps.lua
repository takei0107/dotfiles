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

-- tmap
mappings.noremap('t'):silent():bind('<Esc>', [[<C-\><C-n>]])
