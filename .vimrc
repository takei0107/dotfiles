scriptencoding utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp932,default

let s:vim_features = {
  \ 'vim' : {
  \   'dirs' : {
  \     'cache' : '~/.cache/vim/',
  \   },
  \ },
  \ 'nvim' : {
  \   'dirs' : {
  \     'config' : '~/.config/nvim/',
  \     'cache' : '~/.cache/nvim/',
  \   },
  \ },
  \ }
let s:feature_vim = 'vim'
let s:feature_settings = s:vim_features['vim']
function! s:resolve_vim_feature() abort
  for [feature, settings] in s:vim_features
    if has(feature)
      let s:feature_vim = feature
      let s:feature_settings = settings
      return
    endif
  endfor
endfunction
call s:resolve_vim_feature()

function! s:mkdir_if_not_exist(path) abort
  if !isdirectory(a:path)
    call mkdir(a:path, 'p')
  endif
endfunction

" {{{ 基本設定
filetype off
filetype plugin indent off

let s:cache_dir = expand(s:feature_settings['cache'])
call s:mkdir_if_not_exist(s:dotcache_dir)
let s:config_dir = expand(s:feature_settings['config'])
call s:mkdir_if_not_exist(s:dotconfig_dir)

if has('cursorshape')
  let &t_SI = "\e]50;CursorShape=1\x7"
  let &t_EI = "\e]50;CursorShape=0\x7"
endif

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
  let s:undo_dir = (has('nvim') ? s:dotnvim_dir : s:dotvim_dir) . 'undo'
  call s:mkdir_if_not_exist(s:undo_dir)
  execute 'set undodir=' . s:undo_dir
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

" lsp type 'lsp+ddc:0(default), coc:1'
let g:use_lsp_type = 0
let s:ctr_lsp_type_file = s:dotvim_dir . 'ctr_lsp_type.vim'
if filereadable(s:ctr_lsp_type_file)
  execute 'source ' . s:ctr_lsp_type_file
endif

let s:dein_toml = s:dotvim_dir . 'dein.toml'
let s:dein_lazy_toml = s:dotvim_dir . 'dein_lazy.toml' 
let s:coc_toml = s:dotvim_dir . 'coc.toml'
let s:lsp_toml = s:dotvim_dir . 'lsp.toml'
let s:ddc_toml = s:dotvim_dir . 'ddc.toml'
let s:nvim_toml = s:dotvim_dir . 'nvim.toml'
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
" }}}


" {{{ only Linux
if has('unix')
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
let mapleader = "\<Space>"
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

" {{{ util functions
function! IsExistsInCurrentDirR(path) abort
  let cwd = getcwd()
  let resoleved = Resolve_from_current_path(a:path)
  return IsFileExists(cwd . '/' . resoleved)
endfunction
" 引数のパスをカレントディレクトリから解決する
function! Resolve_from_current_path(path) abort
  return fnamemodify(a:path, ':.')
endfunction
function! IsFileExists(path) abort
  return isdirectory(a:path) || filereadable(a:path)
endfunction
"}}}


filetype plugin indent on
au FileType * setlocal formatoptions-=ro
