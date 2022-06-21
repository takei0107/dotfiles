" {{{ 基本設定

" プラグイン無効化
let g:loaded_tutor_mode_plugin = 1
let g:loaded_2html_plugin = 1

" スクリプトで使う文字コード 
scriptencoding utf-8

" vim内部で使う文字コード
set encoding=utf-8
" ファイルを読み取る文字コード
set fileencodings=ucs-bom,utf-8,cp932,default

" ファイルタイプ検知off
filetype off
" ファイルタイププラグイン、ファイルタイプインデントoff
filetype plugin indent off

" <leader>キー設定
let mapleader = "\<Space>"

" 環境ごとの設定インポート
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
set shiftwidth=0
set softtabstop=-1
set number
set belloff=all
set hlsearch
set incsearch
set ignorecase
set smartcase
set cursorline
set laststatus=2
set wildmenu
set showcmd
set display=truncate
set backspace=indent,eol,start
set list
set updatetime=500
set splitbelow
set splitright
set foldmethod=marker
set noswapfile
set nobackup
if has('persistent_undo')
  let s:cache_dir = get(g:, 'cache_dir')
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
if filereadable(expand('~/.config/vim/plugin_manager.vim'))
  exec "source " .. expand('~/.config/vim/plugin_manager.vim')
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
nnoremap <leader>dG ggVGd<CR>
nnoremap <leader>cG ggVGc
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
nnoremap <silent> tos :split<Bar>wincmd j<Bar>resize 15<Bar>term<CR>
" }}}

" {{{ filetype settings
augroup filetype
  autocmd!
  autocmd FileType java setlocal expandtab shiftwidth=4
  autocmd FileType go setlocal nolist tabstop=4
  autocmd FileType vim setlocal shiftwidth=2 foldmethod=marker foldopen=all foldclose=all
  autocmd FileType sh,zsh setlocal shiftwidth=2
augroup END
"}}}

filetype plugin indent on
au FileType * setlocal formatoptions-=ro
