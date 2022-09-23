local cmd = vim.cmd

local mappings = require('lib.mapping')

---- ##########################
--   #          nmap          #
---- ##########################
mappings.noremap('n'):silent():bind('<Esc><Esc>', function()
	vim.cmd('nohlsearch')
end)

mappings.noremap('n'):silent():bind('<F5>', function()
	require('vimrc'):load()
end)

-- F4で別タブでinit.nvimを開く
mappings.noremap('n'):silent():bind('<F4>', function()
	cmd("tabnew")
	require('vimrc'):open()
	cmd("normal gg")
end)


-- 矢印キーでウィンドウ移動
mappings.noremap('n'):silent():bind('<Up>', '<C-w>k')
mappings.noremap('n'):silent():bind('<Down>', '<C-w>j')
mappings.noremap('n'):silent():bind('<Right>', '<C-w>l')
mappings.noremap('n'):silent():bind('<Left>', '<C-w>h')


---- ##########################
--   #          imap          #
---- ##########################

-- <C-b>で行末にカーソル移動
mappings.noremap('i'):bind([[<C-b>]], function()
	local eol = vim.fn.col('$')
	vim.fn.cursor(0, eol)
end)


---- ##########################
--   #          vmap          #
---- ##########################

-- eで行末まで選択したときに空白文字を含めない
mappings.noremap('v'):bind('$', 'g_')

-- pでペーストしたときにレジスタの中身を変えない
mappings.noremap('v'):bind('p', [[<S-p>]])

---- ##########################
--   #          tmap          #
---- ##########################
mappings.noremap('t'):silent():bind('<Esc>', [[<C-\><C-n>]])
