---@class rc.Util
local M = {}

---@param modname string
---@param callback fun(module: any)
---@return boolean|any pcallと一緒
---@return string|nil pcallと一緒
M.safeRequire = function(modname, callback)
	vim.validate({
		modname = { modname, "string" },
		callback = { callback, "function" },
	})
	local ok, errOrMod = pcall(require, modname)
	if not ok then
		return false, errOrMod
	end
	return pcall(callback, errOrMod)
end

return M
