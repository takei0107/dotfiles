local M = setmetatable({}, {
	__call = function(self, level)
		vim.cmd(string.format("sign define DiagnosticSign%s text=%s texthl=DiagnosticSign%s", level, self[level].symbol, level))
	end
})

M.Error = {
	symbol = '🚨'
}

M.Warn = {
	symbol = '⚠'
}

M.Info = {
	symbol = '🔔'
}

M.Hint = {
	symbol = '🤔'
}

M("Error")
M("Warn")
M("Info")
M("Hint")

return M
