-- vimのapiのラッパーとして利用

local M = {}

local api = vim.api

local util = require('lib.util')

function M.get_hl_by_name(name)
	local hl = api.nvim_get_hl_by_name(name, true)
	return {
		fg = hl.foreground and ('#' .. util.num_to_hex_string(hl.foreground)),
		bg = hl.background and ('#' .. util.num_to_hex_string(hl.background))
	}
end

return M
