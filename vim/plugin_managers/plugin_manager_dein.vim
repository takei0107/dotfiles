let s:config_dir = get(g:config_vars, 'cofig_dir', expand('~/.config/vim/'))
let s:dein_dir = expand('~/.cache/dein/')
let s:dein_repos_dir = s:dein_dir .. 'repos/github.com/Shougo/dein.vim'
let s:dein_toml_dir = s:config_dir .. 'toml/dein/'
let s:dein_lsp_toml_dir = s:dein_toml_dir .. 'lsp/'

" Init dein
let s:dein_enable = 0
function! s:init_dein() abort
  if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repos_dir)
      " NOTE `git clone` はディレクトリも再帰的に作られる
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repos_dir
    endif
    execute 'set runtimepath^=' . s:dein_repos_dir
  endif
  let s:dein_enable = 1
endfunction
call s:init_dein()

if s:dein_enable
  g:dein#auto_recache = 0
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " loac TOMLs
    let s:toml_files = glob(s:dein_toml_dir .. '*.toml')
    for s:toml_file in s:toml_files
      let s:lazy_flg = 0
      " 遅延読み込みファイル
      if fnamemodify(s:toml_file, ':t') =~# '.*_lazy\.toml$'
        let s:lazy_flg = 1
      endif
      call dein#load_toml(s:toml_file, {'lazy' : s:lazy_flg})
      unlet s:lazy_flg
    endfor
    " load LSP settings
    if exists('g:lsp_tomls')
      for s:lsp_toml in g:lsp_tomls
        let s:lsp_toml_path = s:dein_lsp_toml_dir .. s:lsp_toml
        if filereadable(s:lsp_toml_path)
          call dein#load_toml(s:lsp_toml_path, {'lazy' : 0})
        endif
      endfor
    endif

    call dein#end()
    call dein#save_state()
  endif
  if dein#check_install()
    call dein#install()
  endif

  " hook_post_sourceが発火するように
  autocmd VimEnter * call dein#call_hook('post_source')
endif
