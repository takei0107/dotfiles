local M = {}

local function _setopt(name, value)
	vim.opt[name] = value
end

local function _appendopt(name, value)
	vim.opt[name]:append(value)
end

local function _prependopt(name, value)
	vim.opt[name]:prepend(value)
end

local function _prepare(name, value, condition, prefook)
	assert(name, "arg:<name> is required")
	assert(value ~= nil, string.format("arg:<value> is required. name=%s", name))
	assert((type(name) == "string"), "arg:<name> must be string")
	if prefook ~= nil then
		assert((type(prefook) == "function"), "arg:<prefook> must be function")
		prefook()
	end
	local _cond = true
	if condition ~= nil then
		assert(((type(condition) == "function") or (type(condition) == "boolean")),
			"arg:<condition> must be function or boolen")
		if type(condition) == 'function' then
			_cond = condition()
		elseif type(condition) == 'boolean' then
			_cond = condition
		end
	end
	return _cond
end

function M.setopt(name, value, condition, prefook)
	if _prepare(name, value, condition, prefook) then
		_setopt(name, value)
	end
end

function M.appendopt(name, value, condition, prefook)
	if _prepare(name, value, condition, prefook) then
		_appendopt(name, value)
	end
end

function M.prependopt(name, value, condition, prefook)
	if _prepare(name, value, condition, prefook) then
		_prependopt(name, value)
	end
end

return M
