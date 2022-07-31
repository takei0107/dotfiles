local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

local mapping = require('lib.mapping')
mapping.noremap('n'):silent():bind('<leader>ff', builtin.find_files)
mapping.noremap('n'):silent():bind('<leader>gf', builtin.git_files)
mapping.noremap('n'):silent():bind('<leader>fb', function ()
	builtin.buffers({
		only_cwd = true,
		ignore_current_buffer = true,
	})
end)
mapping.noremap('n'):silent():bind('<leader>fg', builtin.help_tags)
mapping.noremap('n'):silent():bind('<leader>rg', builtin.live_grep)

require('telescope').setup({
	defaults = {
		vimgrep_arguments = {
			'rg',
			'--color=never',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case',
			'--hidden',
		},
		mappings = {
			i = {
				['<C-j>'] = actions.move_selection_next,
				['<C-k>'] = actions.move_selection_previous,
				['<C-b>'] = actions.preview_scrolling_up,
				['<C-f>'] = actions.preview_scrolling_down,
				['<C-u>'] = {"<C-u>", type = "command"},
				['<C-s>'] = actions.select_horizontal
			},
			n = {
				['<Esc>'] = { -- デフォルトのactions.closeだと閉じるのが遅いのでnowaitにする
				"<cmd>q!<cr>",
				type = 'command',
				opts = { nowait = true, silent = true }
			},
			['<C-s>'] = actions.select_horizontal
		}
	}
},
})
