local mappings = require('lib.mapping')

mappings.noremap('n'):silent():bind('<Esc><Esc>', function ()
	vim.cmd('nohlsearch')
end)

mappings.noremap('n'):silent():bind('<F5>', function ()
	require('vimrc'):load()
end)
