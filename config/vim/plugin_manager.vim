" load plugin_manager
let s:plugin_manager_name = 'dein'
" let s:plugin_manager_name = 'jetpack'

let s:plugin_manager_script = expand('~/.config/vim/plugin_managers/plugin_manager_' .. s:plugin_manager_name .. '.vim')
if filereadable(s:plugin_manager_script)
  execute "source " .. s:plugin_manager_script
endif


