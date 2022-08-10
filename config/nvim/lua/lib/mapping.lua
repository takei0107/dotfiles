local keymap = vim.keymap

local mapping = {}

function mapping.noremap(mode)
	local self = setmetatable({}, { __index = mapping })
	self._mode = mode
	self._noremap = true
	self._remap = false
	self._silent = false
	self._buffer = false
	return self
end

function mapping.map(mode)
	local self = setmetatable({}, { __index = mapping })
	self._mode = mode
	self._noremap = false
	self._remap = true
	self._silent = false
	self._buffer = false
	return self
end

function mapping:silent()
	self._silent = true
	return self
end

function mapping:buffer(bufnr)
	self._buffer = bufnr
	return self
end

function mapping:bind(lhs, rhs)
	local opts = {}
	if self._noremap then
		opts.noremap = true
	else
		opts.remap = true
	end
	opts.silent = self._silent
	opts.buffer = self._buffer
	keymap.set(self._mode, lhs, rhs, opts)
end

return mapping
