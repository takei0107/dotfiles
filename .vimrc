scriptencoding utf-8

" {{{ 基本設定
filetype off
filetype plugin indent off

let mapleader = "\<Space>"
let s:dotvim_dir = expand('~/.vim') . '/'
let s:dotnvim_dir = expand('~/.nvim') . '/'
if has('cursorshape')
  let &t_SI = "\e]50;CursorShape=1\x7"
  let &t_EI = "\e]50;CursorShape=0\x7"
endif

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp932,default
set helplang=ja
set smartindent autoindent
set number
set belloff=all
set hlsearch
set incsearch
set ignorecase
set smartcase
set cursorline
set number
set laststatus=2
set expandtab
set ts=2
set shiftwidth=0
set wildmenu
set display=truncate
set list
set showcmd
set backspace=indent,eol,start
set updatetime=500
set splitbelow
set splitright
set noswapfile
set nobackup
if has('persistent_undo')
  let undo_dir = (has('nvim') ? s:dotnvim_dir : s:dotvim_dir) . 'undo'
  if !isdirectory(undo_dir)
    call mkdir(undo_dir, 'p')
  endif
  execute 'set undodir=' . undo_dir
  set undofile
endif
if &compatible
  set nocompatible
endif
" }}}


" {{{ dein
let s:dein_dir = expand('~/.cache/dein/')
let s:dein_repo_dir = s:dein_dir . 'repos/github.com/Shougo/dein.vim/'
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

let s:dein_toml = s:dotvim_dir . 'dein.toml'
let s:dein_lazy_toml = s:dotvim_dir . 'dein_lazy.toml' 
let s:coc_toml = s:dotvim_dir . 'coc.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:dein_toml, {'lazy' : 0})
  call dein#load_toml(s:dein_lazy_toml, {'lazy' : 1})
  call dein#load_toml(s:coc_toml, {'lazy' : 0})
  call dein#end()
  call dein#save_state()
endif
if dein#check_install()
  call dein#install()
endif
" }}}
"
syntax on

" {{{ only Linux
if has('linux')
  set clipboard^=unnamedplus,unnamed
endif
" }}}


" {{{ only MAC
if has('mac')
  set clipboard+=unnamed
endif
" }}}


" {{{ Preference
if has('termguicolors')
  set termguicolors
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  highlight LineNr ctermbg=none
  highlight Folded ctermbg=none
  highlight EndOfBuffer ctermbg=none 
endif
" }}}


" {{{ マッピング
inoremap <silent> jj <ESC>
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
" }}}


" {{{ Java
augroup java
  autocmd!
  autocmd FileType java set ts=4
augroup END
" }}}

filetype plugin indent on
