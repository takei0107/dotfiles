local M = {}

function M.fname()
	return vim.env.MYVIMRC
end

function M:load()
	vim.cmd(string.format(':luafile %s', self.fname()))
end

function M:open()
	vim.cmd(string.format(':edit %s', self.fname()))
end

return M