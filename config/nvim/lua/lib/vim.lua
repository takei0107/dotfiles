local M = {}

local cmd = vim.cmd
local env = vim.env
local api = vim.api

local util = require('lib.util')

function M.reload_vimrc()
	local vimrc = env.MYVIMRC
	if vimrc == nil then
		return "env $MYVIMRC is nil"
	end
	local arg = string.format(':luafile %s', vimrc)
	local success, errMsg = pcall(cmd, arg)
	if not success then
		return string.format("error %s", errMsg)
	end
	return nil
end

function M.open_vimrc()
	local vimrc = env.MYVIMRC
	if vimrc == nil then
		print "env $MYVIMRC is nil"
		return
	end
	cmd(string.format("edit %s", vimrc))
end

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
