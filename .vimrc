set nocompatible

" rtp
let g:loaded_remote_plugins = 1
let g:loaded_gzip = 1
let g:loaded_tarPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_netrwPlugin = 1

" backspace
set backspace=indent,eol,start

" バッファ関連
set number
set hidden

" インデント
set smartindent

" コマンドライン補完
set wildmenu
set wildmode=full
set wildoptions=pum

" findコマンドでカレントディレクトリ配下を検索する
execute "set path+=" .. $PWD .. "/**"

" 検索ハイライト
set incsearch
set hlsearch

" statusline
set ruler
set laststatus=2

" スワップファイル,undoファイル
set noswapfile
let s:undodir = $HOME .. "/.vim/undo"
if !isdirectory(s:undodir)
  call mkdir(s:undodir, 'p')
endif
set undofile
execute "set undodir=" .. s:undodir

" 履歴
set history=5000

nnoremap <C-l> <cmd>nohlsearch<CR>

" CとC++で:Manを有効化
augroup c_man
  au!
  au FileType c,cpp :runtime ftplugin/man.vim
augroup END

" 外観
syntax enable
colorscheme industry
if g:colors_name == 'industry'
  hi! link Type Special
  hi! link Statement Special

  hi! link Macro Function
  hi! link Define Function
  hi! link Include Function
  hi! link PreProc Function

  hi! link Constant Identifier

  hi! link String Conceal
  "hi! link SpecialChar String

  hi! link LineNr Conceal
endif

filetype plugin indent on
