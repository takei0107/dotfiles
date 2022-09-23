local M = {}

function M.num_to_hex_string(num)
	return string.format("%x", num)
end

function M.mkdir_if_not_exist(name, flag)
	if (name == nil) or (string.len(name) < 1) then
		vim.api.nvim_err_writeln('mkdir_if_not_exist() failed. <name> is not specified')
		return false
	end
	if flag ~= nil then
		if flag ~= "p" and flag ~= "" then
			vim.api.nvim_err_writeln('mkdir_if_not_exist() failed. <flag> must be "p" or ""')
			return false
		end
	else
		flag = ""
	end
	if (vim.fn.isdirectory(name) == 0) then
		local result = vim.fn.mkdir(name, flag)
		if not result then
			vim.api.nvim_err_writeln('vim.fn.mkdir() failed')
		else
			print(string.format('make directory:%s success', name))
		end
		return result
	end
	return true
end

return M
