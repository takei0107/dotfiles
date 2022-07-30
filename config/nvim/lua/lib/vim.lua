local M = {}

local cmd = vim.cmd
local env = vim.env
local api = vim.api

local util = require('lib.util')

function M.get_hl_by_name(name)
	local hl = api.nvim_get_hl_by_name(name, true)
	local r = {}
	if hl.foreground == nil then
		r.fg = ""
	else
		r.fg = "#" .. util.num_to_hex_string(hl.foreground)
	end
	if hl.background == nil then
		r.bg = ""
	else
		r.bg = "#" .. util.num_to_hex_string(hl.background)
	end
	return r
end

return M
