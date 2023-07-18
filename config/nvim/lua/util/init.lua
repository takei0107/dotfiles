---@class rc.Util
local M = {}

---@param modname string
---@param callback fun(module: any)
---@return boolean|any, string|nil pcallと一緒
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

---@param modname string モジュール名
M.safeRequireWithSideEffect = function(modname)
  vim.validate({
    modname = { modname, "string" },
  })
  local ok, err = pcall(require, modname)
  if not ok then
    print("safeRequire() failed. error: " .. err)
  end
end

return M
