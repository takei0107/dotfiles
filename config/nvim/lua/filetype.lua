vim.cmd [[
augroup filetype
	autocmd!
	autocmd FileType c,cpp setlocal expandtab shiftwidth=2
	autocmd FileType java setlocal expandtab shiftwidth=4
	autocmd FileType jsp setlocal expandtab shiftwidth=2
	autocmd FileType go setlocal tabstop=4
	autocmd FileType vim setlocal tabstop=2
	autocmd FileType lua setlocal tabstop=2
	autocmd FileType sh,zsh setlocal tabstop=2
	autocmd FileType toml setlocal tabstop=2
	autocmd FileType diff setlocal tabstop=2
augroup END
]]
