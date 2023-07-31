set nocompatible

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

" スワップファイル,undoファイル
set noswapfile
let s:undodir = $HOME .. "/.vim/undo"
if !isdirectory(s:undodir)
  call mkdir(s:undodir, 'p')
endif
set undofile

" 履歴
set history=5000

syntax enable
filetype plugin indent on
