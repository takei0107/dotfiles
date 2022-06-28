source ~/.vimrc

" {{{ lua読み込み
let s:lua_dir = get(g:, 'config_dir') .. 'dein/lua-integration/'
let s:lua_file = s:lua_dir .. 'feline.lua'
execute 'luafile ' .. s:lua_file
" }}}

" {{{ ターミナル
tnoremap <C-x> <C-\><C-n>
autocmd TermOpen * startinsert
" }}}
