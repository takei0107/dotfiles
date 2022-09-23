local vimlib = require('lib.vim')
local text = require('tabby.text')

-- header highlight
local hl_head = {
	fg = '#019833', -- vim color
	bg = vimlib.get_hl_by_name('TabLine').bg
}
-- header
local head = {
	{ '  ', hl = hl_head },
	text.separator('', 'TabLine', 'TabLineFill'),
}

local to = require('tabby.presets').tab_only
to.head = head
require("tabby").setup({
	tabline = to
})
