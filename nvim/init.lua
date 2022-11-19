local set = vim.opt
local setlocal = vim.opt_local

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
set.virtualedit = "block"
set.laststatus = 2
set.matchpairs:append("<:>")

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

local function create_scratch_buffer()
	-- return bufnr
	return vim.api.nvim_create_buf(false, true)
end

local function open_split_win_with_buf(bufnr, direction)
	if not direction then
		direction = "v"
	end
	assert(direction == "v" or direction == "s", "args 'direction' is 'v' or 's'")
	vim.api.nvim_command(direction == "v" and "vnew" or "new")
	local winid = vim.fn.win_getid(vim.api.nvim_win_get_number(0))
	vim.api.nvim_win_set_buf(winid, bufnr)
	return winid
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

-- auto-mkdir
-- see https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
local function confirm_should_mkdir(dir)
	local r = false
	vim.ui.input({
		prompt = string.format('"%s" does not exist. Create? [y/n]\n> ', dir),
	}, function(input)
		r = input == "y"
	end)
	return r
end
local function auto_mkdir(dir, force)
	if vim.fn.isdirectory(dir) ~= 1 and (force or confirm_should_mkdir(dir)) then
		vim.fn.mkdir(dir, "p")
	end
end
vim.api.nvim_create_augroup("auto-mkdir", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = "auto-mkdir",
	pattern = "*",
	callback = function(args)
		auto_mkdir(vim.fn.fnamemodify(args.file, ":p:h"), vim.v.cmdbang == 1)
	end,
})

-- keywordprg for lua-vimrc
vim.api.nvim_create_augroup("lua-help", {})
vim.api.nvim_create_autocmd("BufRead", {
	group = "lua-help",
	pattern = "*.lua",
	callback = function(_)
		setlocal.keywordprg = vim.fn.exists(":Vhelp") and ":Vhelp" or ":help"
	end,
})

-- 再利用可能なバッファのテーブル
local buffer_cache_table = setmetatable({}, {
	__index = function(self, _bufname) -- '変数[バッファ名]'でbufnr取得可能
		for bufnr, bufname in pairs(self) do
			if _bufname == bufname then
				if vim.api.nvim_buf_is_valid(bufnr) then
					return bufnr
				else
					self[bufnr] = nil
				end
			end
		end
		return -1
	end,
})
function buffer_cache_table:new()
	return setmetatable({}, getmetatable(self))
end

-- terminal
vim.api.nvim_create_augroup("terminal", {})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = "terminal",
	pattern = "*",
	callback = function()
		vim.cmd("startinsert")
	end,
})

local terminal_key_prefix = "<C-t>"
local function register_keymaps_for_hide_term(bufnr)
	if not bufnr then
		error("arg 'bufnr' is required")
	end
	vim.keymap.set("n", terminal_key_prefix .. "x", "<cmd>hide<CR>", { silent = true, buffer = bufnr })
end

local function get_terminal_buffer_list()
	local l = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
			table.insert(l, bufnr)
		end
	end
	return l
end

local function select_for_open_terminal(terminal_buffer_list)
	local item_for_new = "n"
	local selections = setmetatable({}, {
		__call = function(self)
			local items = {}
			table.insert(items, item_for_new)
			for item, _ in pairs(self) do
				table.insert(items, item)
			end
			return items
		end,
	})
	for i, bufnr in ipairs(terminal_buffer_list) do
		local term_title = vim.api.nvim_buf_get_var(bufnr, "term_title")
		local cmd = string.match(term_title, "term://.*//%d+:(.*)")
		selections[i] = cmd
	end
	local r = -1
	vim.ui.select(selections(), {
		prompt = "select for open(or create) terminal:",
		format_item = function(item)
			if item == item_for_new then
				return "create new terminal buffer"
			end
			return string.format("%s", selections[item])
		end,
	}, function(choice)
		if choice ~= item_for_new then
			r = terminal_buffer_list[choice]
		end
	end)
	return r
end

local function open_terminal(isTab, direction)
	local terminal_buf_list = get_terminal_buffer_list()
	local bufnr = -1
	if not vim.tbl_isempty(terminal_buf_list) then
		bufnr = select_for_open_terminal(terminal_buf_list)
	end
	local isNew = false
	if bufnr == -1 then
		isNew = true
		bufnr = vim.api.nvim_create_buf(true, false)
	end
	local winid = vim.fn.bufwinid(bufnr)
	if winid == -1 then
		winid = open_split_win_with_buf(bufnr, direction)
		if isNew then
			vim.api.nvim_command("terminal")
			register_keymaps_for_hide_term(bufnr)
			return
		end
	end
	vim.fn.win_gotoid(winid)
end

vim.keymap.set("t", "<C-x>", [[<C-\><C-n>]])
vim.keymap.set("n", terminal_key_prefix .. "v", function()
	open_terminal(false, "v")
end, { silent = true })
vim.keymap.set("n", terminal_key_prefix .. "s", function()
	open_terminal(false, "s")
end, { silent = true })
vim.keymap.set("n", terminal_key_prefix .. "t", ":tabnew +terminal<CR>", { silent = true })

-- lua
local _lua = setmetatable({}, {
	__call = function(self)
		vim.api.nvim_create_augroup("lua", {})
		vim.api.nvim_create_autocmd("FileType", {
			group = "lua",
			pattern = "lua",
			callback = function(callback_args)
				setlocal.tabstop = 2
				setlocal.shiftwidth = 2
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
			pattern = { "c", "cpp" },
			callback = function(_)
				setlocal.tabstop = 4
				setlocal.shiftwidth = 4
				setlocal.complete:append("i")
			end,
		})
	end,
})

-- enable/disable language(filetype) settings
_lua()
_c()

-- atCoder
local _atMakeT = {}
function _atMakeT.new(makeprg)
	local t = setmetatable({}, _atMakeT)
	t.makeprg = makeprg
	return t
end
local function register_at_make_command(atMakeT)
	if not atMakeT then
		error("arg 'atMakeT' is nil")
	end
	if not atMakeT.makeprg then
		error("atMakeT.makeprg is nil or false")
	end
	vim.api.nvim_buf_create_user_command(0, "AtMake", function()
		vim.api.nvim_command("cclose")
		setlocal.makeprg = atMakeT.makeprg
		vim.api.nvim_command("make")
		if vim.tbl_isempty(vim.fn.getqflist()) then
			print("AtMake: build ok")
		else
			vim.api.nvim_command("copen")
		end
	end, {})
end

local ft_makeprg = {
	c = "gcc -Wall % -o %<.out -lm",
}
local function ft_patterns()
	local p = {}
	for ft, _ in pairs(ft_makeprg) do
		table.insert(p, ft)
	end
	return p
end

local ac_input_buffers = buffer_cache_table:new()
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
	vim.keymap.set("n", "p", 'gg<S-v>G"+p', { buffer = bufnr })
end

local function create_or_reuse_ac_input_buffer(test_cmd)
	assert(test_cmd, "args 'test_cmd' is required")
	local bufname = string.format("AtTestInput[%s]", test_cmd)
	local bufnr = ac_input_buffers[bufname]
	if bufnr == -1 then
		-- init.luaを再読込した際にバッファ名が被るのを避ける
		local _bufnr = vim.fn.bufnr(vim.fn.bufnr(bufname))
		if vim.fn.bufexists(_bufnr) == 1 then
			bufnr = _bufnr
		else
			bufnr = create_scratch_buffer()
			vim.api.nvim_buf_set_name(bufnr, bufname)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, { "##### Paste the input for testing #####" })
		end
		ac_input_buffers[bufnr] = bufname
	end
	return bufnr
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
	local test_cmd = vim.fn.expand("%:p:r") .. ".out"
	local find_err_msg = find_test_cmd(test_cmd)
	local can = true
	if find_err_msg then
		print(string.format("AtTest: [ERR]%s", find_err_msg))
		can = prompt_for_should_atMake()
	end
	if can then
		if not find_test_cmd(test_cmd) then
			local bufnr = create_or_reuse_ac_input_buffer(test_cmd)
			register_keymaps_for_ac_test(test_cmd, bufnr)
			local winid = vim.fn.bufwinid(bufnr)
			if winid == -1 then
				winid = open_split_win_with_buf(bufnr, "v")
			end
			vim.fn.win_gotoid(winid)
			vim.api.nvim_win_set_cursor(winid, { 1, 0 })
		end
	end
end

vim.api.nvim_create_user_command("AtTest", function()
	atTest()
end, {})

