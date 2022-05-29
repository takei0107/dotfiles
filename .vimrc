scriptencoding utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp932,default
filetype off
filetype plugin indent off
let mapleader = "\<Space>"

" {{{  
" 環境設定インポート
if filereadable(expand('~/.vimrc.env'))
  execute 'source ' .. expand('~/.vimrc.env')
endif
" ローカル設定インポート
if filereadable(expand('~/.vimrc.local'))
  execute 'source ' .. expand('~/.vimrc.local')
endif
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

" {{{ プラグインマネージャー
source vim/plugin_manager.vim
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
