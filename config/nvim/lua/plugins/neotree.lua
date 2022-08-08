-- remove duplicated command
vim.g.neo_tree_remove_legacy_commands = 1

local mapping = require('lib.mapping')
mapping.noremap('n'):bind('<leader>nt', function()
	vim.cmd('Neotree reveal toggle left')
end)

require('neo-tree').setup({
	close_if_last_window = true,
	enable_git_status = true,
	enable_diagnostics = true,
	window = {
		position = 'left',
		width = 30,
		mappings = {
			['s'] = 'open_split',
			['v'] = 'open_vsplit'
		}
	},
	filesystem = {
		filtered_items = {
			hide_dotfiles = false,
			hide_gitignored = false,
		},
		follow_current_file = true,
	},
	event_handlers = {
		{
			event = "file_opened",
			handler = function(arg)
				require("neo-tree").close_all()
			end
		}
	}
})
