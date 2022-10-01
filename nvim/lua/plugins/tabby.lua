return function()
	--require('tabby.tabline').set(function(line)
	--	-- vim.o.showtabline = 2 -- allways show tablne
	local vimlib = require('lib.vim')

	-- header highlight
	local hl_head = {
		fg = '#019833', -- vim color
		bg = vimlib.get_hl_by_name('TabLine').bg
	}

	require('tabby.tabline').use_preset('tab_only', {
		theme = {
			head = hl_head
		}
	})
end
