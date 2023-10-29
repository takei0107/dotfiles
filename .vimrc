set nocompatible

" backspace
set backspace=indent,eol,start

" バッファ関連
set number
set hidden

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

syntax enable
colorscheme industry

filetype plugin indent on
