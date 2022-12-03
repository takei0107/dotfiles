local set = vim.opt
local setlocal = vim.opt_local
local S = vim.env

vim.g.mapleader = " "

-- options {{{
set.belloff = "all"
set.number = true
set.list = true
set.relativenumber = true
set.scrolloff = 5
set.smartindent = true
set.smarttab = true
set.undofile = true
set.swapfile = false
set.splitright = true
set.splitbelow = true
set.cursorline = true
set.cursorlineopt = { "screenline" }
set.virtualedit = "block"
set.laststatus = 2
set.matchpairs:append("<:>")
-- }}}

-- {{{ keymaps
-- same as <C-L>
-- vim.keymap.set("n", "<ESC><ESC>", "<cmd>nohlsearch<CR><ESC>", { silent = true })

vim.keymap.set("i", "(", "()<ESC>i")
vim.keymap.set("i", "[", "[]<ESC>i")
vim.keymap.set("i", "{", "{}<ESC>i")
vim.keymap.set("i", "<", "<><ESC>i")
vim.keymap.set("i", '"', '""<ESC>i')
vim.keymap.set("i", "'", "''<ESC>i")

vim.keymap.set("v", "$", "g_")

vim.keymap.set({ "o", "x" }, 'a"', '2i"')
vim.keymap.set({ "o", "x" }, "a'", "2i'")
vim.keymap.set({ "o", "x" }, "a`", "2i`")

-- 'f'の後ろからバージョン
-- ';'対応
vim.keymap.set({ "n", "x" }, "<leader>f", function()
	local c = vim.fn.getcharstr()
	vim.cmd(string.format("normal F%s<CR>", c)) -- ';'でリピートできるように
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local row = cursor_pos[1] - 1
	local col_start = cursor_pos[2] + 1
	local col_end = vim.fn.col("$") - 1
	if col_start >= col_end then
		return
	end
	local searched = vim.api.nvim_buf_get_text(vim.fn.bufnr(), row, col_start, row, col_end, {})[1]:reverse()
	local index, _ = searched:find(c, 1, true)
	if index then
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], col_end - index })
	end
end)

-- reload vimrc
vim.keymap.set("n", "<F5>", function()
	local vimrc = S.MYVIMRC
	vim.cmd("luafile " .. vimrc)
	print(string.format("%s reloaded", vimrc))
end)

-- CTRL+kで+レジスタにモーションを指定してヤンク(macだと*レジスタの方がいいかも)
vim.keymap.set("n", "<C-k>", '"+y')
-- CTRL+k+%で+レジスタにバッファの内容をヤンク
vim.keymap.set("n", "<C-k>%", ":%y +<CR>")

-- popup-menuが出ているときに<CR>で選択する
vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-Y>"
	else
		return "<CR>"
	end
end, {
	expr = true,
})
-- }}}

-- {{{ _G functions
_G.pp = function(arg)
	vim.pretty_print(arg)
end

_G.termcodes = function(key)
	return vim.api.nvim_replace_termcodes(key, true, true, true)
end
-- }}}

-- {{{ local functions
-- vimscriptの関数呼び出しなので1-indexed
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

-- {1,2},{"hoge", "fuga"} => {1,2,"hoge","fuga"}
local function tbl_merge_simple(...)
	local r = setmetatable({}, {
		__concat = function(self, other)
			for _, v in ipairs(other) do
				table.insert(self, v)
			end
			return self
		end,
	})
	for i = 1, select("#", ...) do
		r = r .. (select(i, ...))
	end
	return setmetatable(r, nil)
end

local function get_marked_range(mark_start, mark_end)
	local start_row, start_col, end_row, end_col =
		unpack(tbl_merge_simple(vim.api.nvim_buf_get_mark(0, mark_start), vim.api.nvim_buf_get_mark(0, mark_end)))
	return start_row - 1, start_col, end_row - 1, end_col
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
-- }}}

-- {{{ surround
local surrounder = {
	get_left = function(self)
		return self.pair.l
	end,
	get_right = function(self)
		return self.pair.r
	end,
	exec = function(self, lines)
		if not lines then
			error("arg:<lines> is nil")
		end
		if not self.pair then
			error("property:<pair> is nil")
		end
		local e = #lines
		if e < 1 then
			error("at least 1 line required (arg:<lines>)")
		end
		local surrounded = {}
		for i, line in ipairs(lines) do
			if i == 1 then
				line = self.pair.l .. line
			end
			if i == e then
				line = line .. self.pair.r
			end
			table.insert(surrounded, line)
		end
		return surrounded
	end,
	delete = function(self, lines)
		local end_line = lines[#lines]
		local end_line_len = (end_line):len()
		local start_str, end_str = lines[1]:sub(1, 1), end_line:sub(end_line_len, end_line_len)
		local deleted = {}
		if start_str == self:get_left() and end_str == self:get_right() then
			for i, line in ipairs(lines) do
				if i == 1 then
					line = (line):sub(2)
				end
				if i == #lines then
					line = (line):sub(0, (line):len() - 1)
				end
				table.insert(deleted, line)
			end
			return deleted
		else
			return nil
		end
	end,
}
surrounder.new = function(_, pair)
	if not pair then
		error("arg:<pair> is nil")
	end
	local obj = setmetatable({
		pair = pair,
	}, { __index = surrounder })
	return obj
end
local surrounders = {
	register = function(self, l, r)
		self[l] = surrounder:new({ l = l, r = r })
	end,
	exists = function(self, l)
		return vim.tbl_contains(vim.tbl_keys(self), l)
	end,
	is_pair_match = function(self, l, r)
		if self.l == l and self.r == r then
			return true
		end
		return false
	end,
}
surrounders:register("(", ")")
surrounders:register("[", "]")
surrounders:register("{", "}")
surrounders:register("<", ">")
surrounders:register("'", "'")
surrounders:register('"', '"')

local function surround_exec(input, lines)
	if not input then
		error("arg:<input> is nil")
	end
	if not lines then
		error("arg:<lines> is nil")
	end
	if not surrounders:exists(input) then
		return
	end
	return surrounders[input]:exec(lines)
end
local function get_visualed_range()
	local start_pos = _getpos("v")
	local end_pos = _getpos(".")
	return start_pos.lnum - 1, start_pos.col - 1, end_pos.lnum - 1, end_pos.col - 1
end
local function surround(is_opfunc)
	local get_range_fn = get_visualed_range
	if is_opfunc then
		setlocal.opfunc = ""
		_G.surround = nil
		get_range_fn = function()
			return get_marked_range("[", "]")
		end
	end
	local start_row, start_col, end_row, end_col = get_range_fn()
	local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col + 1, {})
	local l = vim.fn.getcharstr()
	if not surrounders:exists(l) then
		return
	end
	local surrounded = surround_exec(l, lines)
	--print(("start_row = %d, start_col = %d, end_row = %d, end_col = %d"):format(start_row, start_col, end_row, end_col))
	vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col + 1, surrounded)
end
local function issue_opfunc()
	_G.surround = surround
	setlocal.opfunc = "v:lua.surround"
	return "g@"
end
vim.keymap.set("n", "sa", function()
	return issue_opfunc()
end, { expr = true })
vim.keymap.set("x", "sa", function()
	surround(nil)
	vim.api.nvim_feedkeys(termcodes("<ESC>"), "v", false)
	local start_pos = _getpos("v")
	vim.api.nvim_win_set_cursor(vim.fn.bufwinid(vim.api.nvim_win_get_buf(0)), { start_pos.lnum, start_pos.col - 1 })
end)
vim.keymap.set("x", "sd", function()
	local l = vim.fn.getcharstr()
	if surrounders:exists(l) then
		local start_row, start_col, end_row, end_col = get_visualed_range()
		local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col + 1, {})
		local deleted = surrounders[l]:delete(lines)
		if deleted then
			vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col + 1, deleted)
		end
	end
	vim.api.nvim_feedkeys(termcodes("<ESC>"), "v", false)
end)

-- }}}

-- {{{ help
-- helpをvsplitで開く
vim.api.nvim_create_user_command("Vhelp", function(opts)
	vim.api.nvim_command("vertical help " .. opts.args)
end, {
	nargs = 1,
	complete = "help",
})
-- }}}

-- {{{ fold vimrc
local vimrc_dir = vim.fn.fnamemodify(S.MYVIMRC, ":p:h")
vim.api.nvim_create_augroup("fold-method", {})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = "fold-method",
	pattern = { vimrc_dir .. "/*.lua", vimrc_dir .. "/*/*.lua" },
	callback = function(_)
		set.foldmethod = "marker"
	end,
})
-- }}}

--  {{{ auto-mkdir
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
-- }}}

-- {{{ keywordprg for lua-vimrc
vim.api.nvim_create_augroup("lua-help", {})
vim.api.nvim_create_autocmd("BufRead", {
	group = "lua-help",
	pattern = "*.lua",
	callback = function(_)
		setlocal.keywordprg = vim.fn.exists(":Vhelp") and ":Vhelp" or ":help"
	end,
})
-- }}}

-- {{{ buffer
-- 再利用可能なバッファのテーブル
local buffer_cache_table = setmetatable({}, {
	__index = function(self, name) -- '変数[バッファ名]'でbufnr取得可能
		for bufnr, bufname in pairs(self) do
			if name == bufname then
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
-- }}}

--  {{{ terminal
local terminal_key_prefix = "<C-t>"

local before_open_term = {}
vim.api.nvim_create_augroup("terminal", {})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = "terminal",
	pattern = "*",
	callback = function(_)
		vim.cmd("startinsert")
	end,
})
vim.api.nvim_create_autocmd({ "TermClose" }, {
	group = "terminal",
	pattern = "*",
	callback = function(callback_args)
		if not vim.tbl_isempty(before_open_term) then
			if before_open_term.bufnr then
				if callback_args.buf == before_open_term.bufnr then
					before_open_term = {}
				end
			end
		end
	end,
})

local function toggle_term()
	if vim.tbl_isempty(before_open_term) then
		print("no terminal buffer is available")
		return
	end
	if before_open_term.bufnr then
		local winid = vim.fn.bufwinid(before_open_term.bufnr)
		if winid == -1 then
			winid = open_split_win_with_buf(before_open_term.bufnr, before_open_term.direction or "v")
		end
		vim.fn.win_gotoid(winid)
	end
end

vim.keymap.set("n", terminal_key_prefix .. "x", function()
	toggle_term()
end, { silent = true })
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
	before_open_term = { bufnr = bufnr, direction = direction or "v" }
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
-- }}}

-- {{{1 lua
-- {{{2 luacheck
local luacheck = function(path)
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
-- }}}2

-- {{{2 stylua
local stylua = function()
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
-- }}}2
-- }}}1

-- {{{1 lang settings
local lang_settings = setmetatable({
	expandtab = false,
	tabstop = 2,
	shiftwidth = 0,
	configure = nil,
}, {
	__call = function(self, args)
		setlocal.expandtab = self.expandtab
		setlocal.tabstop = self.tabstop
		setlocal.shiftwidth = self.shiftwidth
		if self.configure then
			self.configure(args)
		end
	end,
})
function lang_settings:new(override)
	local new = vim.tbl_extend("force", self, override)
	setmetatable(new, getmetatable(self))
	return new
end
local langs = setmetatable({}, {
	__index = function(self)
		return lang_settings
	end,
	__newindex = function(self, key, value)
		local settings = lang_settings:new(value)
		if type(key) == "string" then
			rawset(self, key, settings)
		elseif type(key) == "table" then
			for _, v in ipairs(key) do
				rawset(self, v, settings)
			end
		end
	end,
})

-- {{{2 langs
-- {{{3 lua
langs["lua"] = {
	configure = function(args)
		vim.api.nvim_buf_create_user_command(args.buf, "LuaCheck", function(opts)
			luacheck(opts.args)
		end, {
			nargs = "?",
			complete = "file",
		})
		vim.api.nvim_buf_create_user_command(args.buf, "LuaCheckCurrent", function()
			luacheck(vim.fn.expand("%"))
		end, {})
		vim.api.nvim_create_augroup("stylua", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = "stylua",
			pattern = "*.lua",
			callback = function()
				stylua()
			end,
		})
	end,
}
-- }}}3
-- {{{3 c, cpp
langs[{ "c", "cpp" }] = {
	tabstop = 4,
	configure = function(_)
		setlocal.complete:append("i")
	end,
}
-- }}}
-- }}}2

vim.api.nvim_create_augroup("lang", {})
vim.api.nvim_create_autocmd("Filetype", {
	group = "lang",
	pattern = "*",
	callback = function(args)
		langs[args.match](args)
	end,
})
-- }}}1

-- {{{ atCoder
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
-- }}}

