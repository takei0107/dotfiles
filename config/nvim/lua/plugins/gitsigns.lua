local mapping = require('lib.mapping')

require('gitsigns').setup({
	on_attach = function (bufnr)
		local gs = require('gitsigns')
		mapping.noremap('n'):silent():bind(']c', function ()
			vim.schedule(function ()
				gs.next_hunk()
			end)
		end)
		mapping.noremap('n'):silent():bind('[c', function ()
			vim.schedule(function ()
				gs.prev_hunk()
			end)
		end)
	end
})
