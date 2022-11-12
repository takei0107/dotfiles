local set = vim.opt
set.number = true
set.list = true
set.scrolloff = 5
set.smartindent = true
set.undofile = true
set.swapfile = false
set.splitright = true
set.splitbelow = true
set.cursorline = true
set.cursorlineopt = { "screenline" }
set.laststatus = 2

-- same as <C-L>
-- vim.keymap.set("n", "<ESC><ESC>", "<cmd>nohlsearch<CR><ESC>", { silent = true })

vim.keymap.set("i", "(", "()<ESC>i")
vim.keymap.set("i", "[", "[]<ESC>i")
vim.keymap.set("i", "{", "{}<ESC>i")
vim.keymap.set("i", '"', '""<ESC>i')
vim.keymap.set("i", "'", "''<ESC>i")

vim.keymap.set("v", "$", "g_")

vim.keymap.set("n", "<F5>", function()
	local vimrc = vim.env.MYVIMRC
	vim.cmd("luafile " .. vimrc)
	print(string.format("%s reloaded", vimrc))
end)

-- CTRL+kで+レジスタにモーションを指定してヤンク(macだと*レジスタの方がいいかも)
vim.keymap.set("n", "<C-k>", '"+y')
-- CTRL+k+%で+レジスタにバッファの内容をヤンク
vim.keymap.set("n", "<C-k>%", ":%y +<CR>")

_G.pp = function(arg)
	vim.pretty_print(arg)
end

_G.termcodes = function(key)
	return vim.api.nvim_replace_termcodes(key, true, true, true)
end

local function _getpos(expr)
	local pos = vim.fn.getpos(expr)
	return { bufnum = pos[1], lnum = pos[2], col = pos[3], off = pos[4] }
end

local function _join_buf_all_lines(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
	return vim.fn.join(lines, "\n")
end

local function surround(pair)
	if not pair then
		error("pair required")
	end
	if not pair.l or not pair.r then
		pp(pair)
		error("pair must be a table ( { l, r } ).")
	end
	local v_start = _getpos("v")
	local v_end = _getpos(".")
	local start_relative_lnum = 1
	local end_relative_lnum = v_end.lnum - v_start.lnum + 1
	local lines =
		vim.api.nvim_buf_get_text(vim.fn.bufnr(), v_start.lnum - 1, v_start.col - 1, v_end.lnum - 1, v_end.col, {})
	if vim.tbl_isempty(lines) then
		error("lines is empty")
	end
	local surroundes_lines = {}
	for i, line in ipairs(lines) do
		if i == start_relative_lnum then
			line = pair.l .. line
		end
		if i == end_relative_lnum then
			line = line .. pair.r
		end
		table.insert(surroundes_lines, line)
	end
	vim.api.nvim_buf_set_text(
		vim.fn.bufnr(),
		v_start.lnum - 1,
		v_start.col - 1,
		v_end.lnum - 1,
		v_end.col,
		surroundes_lines
	)
	-- return modiefied position
	return v_end.lnum, (v_start.lnum == v_end.lnum) and v_end.col + 2 or v_end.col + 1
end

local function register_surround_pairs()
	local surround_pairs = {
		{ l = "(", r = ")" },
		{ l = "{", r = "}" },
		{ l = "[", r = "]" },
		{ l = "<", r = ">" },
		{ l = "'", r = "'" },
		{ l = '"', r = '"' },
	}
	for _, pair in ipairs(surround_pairs) do
		vim.keymap.set("v", "sa" .. pair.l, function()
			local mod_lnum, mod_col = surround({ l = pair.l, r = pair.r })
			vim.fn.cursor(mod_lnum, mod_col)
			vim.api.nvim_feedkeys(termcodes("<ESC>"), "v", false)
		end, { silent = true })
	end
end
register_surround_pairs()

-- helpをvsplitで開く
vim.api.nvim_create_user_command("Vhelp", function(opts)
	vim.api.nvim_command("vertical help " .. opts.args)
end, {
	nargs = 1,
	complete = "help",
})

-- terminal
vim.api.nvim_create_augroup("terminal", {})
vim.api.nvim_create_autocmd("TermOpen", {
	group = "terminal",
	pattern = "*",
	callback = function()
		vim.cmd("startinsert")
	end,
})
vim.keymap.set("t", "<C-x>", [[<C-\><C-n>]])
vim.keymap.set("n", "<C-t>t", ":tabnew +terminal<CR>", { silent = true })
vim.keymap.set("n", "<C-t>s", ":new <bar> :terminal<CR>", { silent = true })
vim.keymap.set("n", "<C-t>v", ":vnew <bar> :terminal<CR>", { silent = true })

-- lua
local _lua = setmetatable({}, {
	__call = function(self)
		vim.api.nvim_create_augroup("lua", {})
		vim.api.nvim_create_autocmd("FileType", {
			group = "lua",
			pattern = "lua",
			callback = function(callback_args)
				vim.opt_local.tabstop = 2
				vim.opt_local.shiftwidth = 2
				vim.api.nvim_buf_create_user_command(callback_args.buf, "LuaCheck", function(opts)
					self.luacheck(opts.args)
				end, {
					nargs = "?",
					complete = "file",
				})
				vim.api.nvim_buf_create_user_command(callback_args.buf, "LuaCheckCurrent", function()
					self.luacheck(vim.fn.expand("%"))
				end, {})
			end,
		})
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = "lua",
			pattern = "*.lua",
			callback = function()
				self.stylua()
			end,
		})
	end,
})

-- luacheck
_lua.luacheck = function(path)
	if vim.fn.executable("luacheck") ~= 1 then
		error("luacheck is not installed")
		return
	end
	local efm_tmp = vim.opt.errorformat
	local mkp_tmp = vim.opt.makeprg
	path = ((path == nil) or (string.len(path) == 0)) and "**/*.lua" or path
	vim.opt.errorformat = { [[%f:%l:%c: %m]], [[%s: %m (couldn't read: No such file or directory)]] }
	vim.opt.makeprg = string.format("luacheck %s --formatter plain", path)
	local ok, err = pcall(vim.cmd, "make")
	if ok then
		local need_copen = true
		local qflist_size = vim.fn.getqflist({ size = 0 }).size
		if qflist_size == 1 then
			if vim.fn.getqflist({ items = 0 }).items[1].text == "I/O error" then
				need_copen = false
				print(":make error")
			end
		elseif qflist_size == 0 then
			need_copen = false
		end
		if need_copen then
			ok, err = pcall(vim.cmd, "copen")
		end
	end
	vim.opt.errorformat = efm_tmp
	vim.opt.makeprg = mkp_tmp
	if not ok then
		error(err)
	end
end

-- stylua
_lua.stylua = function()
	if vim.fn.executable("stylua") ~= 1 then
		error("stylua is not installed")
	end
	local joined = _join_buf_all_lines(vim.fn.bufnr())
	local out = vim.fn.system("stylua -", joined)
	if vim.v.shell_error ~= 0 then
		error(out)
	end
	local new_lines = vim.split(out, "\n")
	vim.api.nvim_buf_set_lines(vim.fn.bufnr(), 0, -1, true, new_lines)
end

-- C
local _c = setmetatable({}, {
	__call = function(_)
		vim.api.nvim_create_augroup("c", {})
		vim.api.nvim_create_autocmd("FileType", {
			group = "c",
			pattern = "c",
			callback = function(_)
				vim.opt_local.tabstop = 4
				vim.opt_local.shiftwidth = 4
			end,
		})
	end,
})

-- enable/disable language(filetype) settings
_lua()
_c()

-- atcoder
local _atMakeT = {}
function _atMakeT.new(makeprg)
	local t = setmetatable({}, _atMakeT)
	t.makeprg = makeprg
	return t
end
local function register_at_make_command(atMakeT)
	if not atMakeT then
		error("arg:<atMakeT> is nil")
	end
	if not atMakeT.makeprg then
		error("atMakeT.makeprg is nil or false")
	end
	vim.api.nvim_buf_create_user_command(0, "AtMake", function()
		vim.api.nvim_command("cclose")
		vim.opt_local.makeprg = atMakeT.makeprg
		vim.api.nvim_command("make")
		if vim.tbl_isempty(vim.fn.getqflist()) then
			print("AtMake: build ok")
		else
			vim.api.nvim_command("copen")
		end
	end, {})
end

local ft_makeprg = {
	c = "gcc -Wall % -o %<.out",
}
local function ft_patterns()
	local p = {}
	for ft, _ in pairs(ft_makeprg) do
		table.insert(p, ft)
	end
	return p
end

vim.api.nvim_create_augroup("atCoder", {})
vim.api.nvim_create_autocmd("FileType", {
	group = "atCoder",
	pattern = ft_patterns(),
	callback = function(callback_args)
		local t = {}
		local makeprg = ft_makeprg[callback_args.match]
		if makeprg then
			t = _atMakeT.new(makeprg)
		end
		if not vim.tbl_isempty(t) then
			register_at_make_command(t)
		end
	end,
})

local function open_scratch_buffer_window(direction)
	local default_direction = "v"
	if direction and (direction ~= "v" and direction ~= "s") then
		error("direction is 'v' or 's' or nil")
	end
	if not direction then
		direction = default_direction
	end
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_command(direction == "v" and "vnew" or "new")
	local winnr = vim.api.nvim_win_get_number(0)
	local winid = vim.fn.win_getid(winnr)
	vim.api.nvim_win_set_buf(winid, bufnr)
	return bufnr, winnr
end

local function exec_ac_test(test_cmd, input)
	local out = vim.fn.system(test_cmd, input)
	print("AtTest: out -> " .. out)
end

local function register_keymaps_for_ac_test(test_cmd, bufnr)
	if not test_cmd or not bufnr then
		error("2 arguments required")
	end
	vim.keymap.set("c", "w<CR>", function()
		local input = _join_buf_all_lines(bufnr)
		exec_ac_test(test_cmd, input)
	end, { silent = true, buffer = bufnr })
end

local function create_ac_input_window()
	local bufnr, winnr = open_scratch_buffer_window("v")
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, { "##### Paste the input for testing #####" })
	return bufnr, winnr
end

local function find_test_cmd(test_cmd)
	if vim.fn.executable(test_cmd) ~= 1 then
		return string.format("executable file '%s' does not exist", test_cmd)
	end
	return nil
end

local function prompt_for_should_atMake()
	local done = false
	vim.ui.input({
		prompt = "Should run command 'AtTest'? Input [y]es or [n]o.\n> ",
	}, function(input)
		if not input then
			return
		end
		if input ~= "y" and input ~= "n" then
			error("input is [y]es or [n]o")
		end
		if input == "n" then
			return
		end
		vim.api.nvim_command("AtMake")
		done = true
	end)
	return done
end

local function atTest()
	local test_cmd = vim.fn.expand("%:r") .. ".out"
	local find_err_msg = find_test_cmd(test_cmd)
	local can = true
	if find_err_msg then
		print(string.format("AtTest: [ERR]%s", find_err_msg))
		can = prompt_for_should_atMake()
	end
	if can then
		local bufnr, winnr = create_ac_input_window()
		register_keymaps_for_ac_test(test_cmd, bufnr)
		local winid = vim.fn.win_getid(winnr)
		vim.api.nvim_win_set_cursor(winid, { 1, 0 })
	end
end

vim.api.nvim_create_user_command("AtTest", function()
	atTest()
end, {})

