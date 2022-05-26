scriptencoding utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp932,default
filetype off
filetype plugin indent off
let mapleader = "\<Space>"

" {{{  ローカル設定インポート
if filereadable(expand('~/.vimrc.local'))
  execute 'source ' .. expand('~/.vimrc.local')
endif
" TODO 変数の存在有無によって処理分ける？
let s:config_dir = g:config_dir
let s:cache_dir = g:cache_dir
let s:dein_dir = g:dein_dir
let s:dein_repo_dir = g:dein_repo_dir
unlet g:config_dir
unlet g:cache_dir
unlet g:dein_dir
unlet g:dein_repo_dir
" }}}

" {{{ カーソル
if has('cursorshape')
  let &t_SI = "\e]50;CursorShape=1\x7"
  let &t_EI = "\e]50;CursorShape=0\x7"
endif
" }}}

" {{{ オプション
set hidden
set helplang=ja
set smartindent 
set autoindent
set expandtab
set tabstop=2
set shiftwidth=0
set number
set belloff=all
set hlsearch
set incsearch
set ignorecase
set smartcase
set cursorline
set number
set laststatus=2
set wildmenu
set showcmd
set display=truncate
set backspace=indent,eol,start
set list
set updatetime=500
set splitbelow
set splitright
set noswapfile
set nobackup
if has('persistent_undo')
  let s:undo_dir = s:cache_dir . 'undo'
  if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, '')
  endif
  execute 'set undodir=' . s:undo_dir
  set undofile
endif
if &compatible
  set nocompatible
endif
if has('unix')
  set clipboard^=unnamedplus,unnamed
elseif has('mac')
  set clipboard+=unnamed
endif
" }}}

" {{{ dein
let s:dein_enable = v:false
function! s:init_dein() abort
  if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
      " NOTE `git clone` はディレクトリも再帰的に作られる
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . s:dein_repo_dir
  endif
  let s:dein_enable = v:true
endfunction
call s:init_dein()

" lsp type 'lsp+ddc:0(default), coc:1'
" TODO LSPのキーマップを共通インターフェースにしてうまいこと制御したい
let g:use_lsp_type = 0
let s:ctr_lsp_type_file = s:config_dir . 'ctr_lsp_type.vim'
if filereadable(s:ctr_lsp_type_file)
  execute 'source ' . s:ctr_lsp_type_file
endif

if s:dein_enable
  " TODO toml廃止検討
  let s:dein_toml = s:config_dir . 'dein.toml'
  let s:dein_lazy_toml = s:config_dir . 'dein_lazy.toml' 
  let s:coc_toml = s:config_dir . 'coc.toml'
  let s:lsp_toml = s:config_dir . 'lsp.toml'
  let s:ddc_toml = s:config_dir . 'ddc.toml'
  let s:nvim_toml = s:config_dir . 'nvim.toml'
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml(s:dein_toml, {'lazy' : 0})
    if (g:use_lsp_type == 0)
      call dein#load_toml(s:lsp_toml, {'lazy' : 0})
      call dein#load_toml(s:ddc_toml, {'lazy' : 0})
    else
      call dein#load_toml(s:coc_toml, {'lazy' : 0})
    endif
    if has('nvim')
      call dein#load_toml(s:nvim_toml, {'lazy' : 0})
    endif
    call dein#load_toml(s:dein_lazy_toml, {'lazy' : 1})
    call dein#end()
    call dein#save_state()
  endif
  if dein#check_install()
    call dein#install()
  endif
  " hook_post_sourceが発火するように
  autocmd VimEnter * call dein#call_hook('post_source')
endif
" }}}

" {{{ Preference
if has('termguicolors')
  set termguicolors
  highlight Normal guibg=NONE
  highlight NonText guibg=NONE
  highlight LineNr guibg=NONE
  highlight Folded guibg=NONE
  highlight EndOfBuffer guibg=NONE 
  highlight CursorLineSign guibg=NONE
  highlight CursorLineFold guibg=NONE
  highlight SignColumn guibg=NONE
endif
" }}}


" {{{ マッピング
inoremap jj <ESC>
nnoremap j gj
nnoremap k gk
nnoremap v$ vg_
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
nnoremap <silent> tos :split<Bar>wincmd j<Bar>resize 15<Bar>term<CR>
" }}}


" {{{ Java
augroup java
  autocmd!
  autocmd FileType java setlocal ts=4
augroup END
" }}}


" {{{ Go
augroup go
  autocmd!
  autocmd FileType go setlocal nolist
augroup END
" }}}

filetype plugin indent on
au FileType * setlocal formatoptions-=ro
