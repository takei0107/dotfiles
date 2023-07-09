-- alias {{{
local set = vim.opt
local setlocal = vim.opt_local
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local S = vim.env
-- }}}

-- options {{{
set.belloff = "all"
set.number = true
set.list = true
set.relativenumber = true
set.scrolloff = 5
set.smartcase = true
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
set.signcolumn = "yes"
set.cmdheight = 0
set.completeopt = "menu"
set.matchpairs:append("<:>")
set.nrformats:append("unsigned")
-- }}}

-- highlight{{{
vim.cmd("hi SignColumn ctermbg=none")
vim.cmd("hi SignColumn guibg=none")
-- }}}

-- {{{ keymaps

-- see ":h map-table"
----------------------------------------------------------------------
--          Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
-- Command        +------+-----+-----+-----+-----+-----+------+------+
-- [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
-- n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
-- [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
-- i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
-- c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
-- v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
-- x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
-- s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
-- o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
-- t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
-- l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
----------------------------------------------------------------------

vim.g.mapleader = " "

-- same as <C-L>
-- vim.keymap.set("n", "<ESC><ESC>", "<cmd>nohlsearch<CR><ESC>", { silent = true })

-- '*','#'による検索で次の一致に自動的に飛ばないようにする
-- see ':h restore-position'
keymap.set("n", "*", "msHmt`s*'tzt`s")
keymap.set("n", "#", "msHmt`s#'tzt`s")

keymap.set("x", "$", "g_")

-- ビジュアルの'p'で無名レジスタ更新しない
keymap.set("x", "p", "P")

keymap.set({ "o", "x" }, 'a"', '2i"')
keymap.set({ "o", "x" }, "a'", "2i'")
keymap.set({ "o", "x" }, "a`", "2i`")

keymap.set({ "n", "x" }, "x", '"_x')
keymap.set({ "n", "x" }, "X", '"_X')
keymap.set({ "n", "x" }, "s", '"_s')
keymap.set({ "n", "x" }, "S", '"_S')

-- 'f'の後ろからバージョン
-- ';'リピート対応
keymap.set({ "n", "x" }, "<leader>f", function()
	local c = fn.getcharstr()
	vim.cmd(string.format("normal F%s<CR>", c)) -- ';'でリピートできるように
	local cursor_pos = api.nvim_win_get_cursor(0)
	local row = cursor_pos[1] - 1
	local col_start = cursor_pos[2] + 1
	local col_end = fn.col("$") - 1
	if col_start >= col_end then
		return
	end
	local searched = api.nvim_buf_get_text(fn.bufnr(), row, col_start, row, col_end, {})[1]:reverse()
	local index, _ = searched:find(c, 1, true)
	if index then
		api.nvim_win_set_cursor(0, { cursor_pos[1], col_end - index })
	end
end)

-- reload vimrc
keymap.set("n", "<F5>", function()
	local vimrc = S.MYVIMRC
	vim.cmd("luafile " .. vimrc)
	print(string.format("%s reloaded", vimrc))
end)

-- CTRL+kで+レジスタにモーションを指定してヤンク(macだと*レジスタの方がいいかも)
keymap.set("n", "<C-k>", '"+y')
-- CTRL+k+%で+レジスタにバッファの内容をヤンク
keymap.set("n", "<C-k>%", ":%y +<CR>")

-- popup-menuが出ているときに<CR>で選択する
keymap.set("i", "<CR>", function()
	if fn.pumvisible() == 1 then
		return "<C-Y>"
	else
		return "<CR>"
	end
end, {
	expr = true,
})
-- }}}

-- {{{ commands

-- ":Of オプション名" で設定値表示
vim.cmd([[command! -nargs=1 -complete=option Of execute("echo &"..expand("<args>"))]])

-- }}}

-- {{{ _G functions
_G.pp = function(arg)
	vim.print(arg)
end

_G.termcodes = function(key)
	return api.nvim_replace_termcodes(key, true, true, true)
end
-- }}}

-- {{{ local functions
-- vimscriptの関数呼び出しなので1-indexed
local function _getpos(expr)
	local pos = fn.getpos(expr)
	return { bufnum = pos[1], lnum = pos[2], col = pos[3], off = pos[4] }
end

local function _join_buf_all_lines(bufnr)
	local lines = api.nvim_buf_get_lines(bufnr, 0, -1, true)
	return fn.join(lines, "\n")
end

local function create_scratch_buffer()
	-- return bufnr
	return api.nvim_create_buf(false, true)
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
	for _, v in ipairs({ ... }) do
		r = r .. v
	end
	return setmetatable(r, nil)
end

local function get_marked_range(mark_start, mark_end)
	local start_row, start_col, end_row, end_col =
		unpack(tbl_merge_simple(api.nvim_buf_get_mark(0, mark_start), api.nvim_buf_get_mark(0, mark_end)))
	return start_row - 1, start_col, end_row - 1, end_col
end

local function open_split_win_with_buf(bufnr, direction)
	if not direction then
		direction = "v"
	end
	assert(direction == "v" or direction == "s", "args 'direction' is 'v' or 's'")
	api.nvim_command(direction == "v" and "vnew" or "new")
	local winid = fn.win_getid(api.nvim_win_get_number(0))
	api.nvim_win_set_buf(winid, bufnr)
	return winid
end

-- }}}

-- {{{ surround

local surrounder = {
	get_left = function(self)
		return self.pair.l or self.pair.left
	end,
	get_right = function(self)
		return self.pair.r or self.pair.right
	end,
}

function surrounder:new(pair)
	assert(pair, "bad argument 'pair'. table expected, but nil")
	assert(pair.l or pair.left, "bad property 'pair.l'. value required, but nil")
	assert(pair.r or pair.right, "bad property 'pair.r'. value required, but nil")

	return setmetatable({
		pair = pair,
	}, {
		__index = self,
	})
end

surrounder.exec = function(self, lines)
	local surrounded = {}
	local e = #lines
	for i, line in ipairs(lines) do
		if i == 1 then
			line = self:get_left() .. line
		end
		if i == e then
			line = line .. self:get_right()
		end
		table.insert(surrounded, line)
	end
	return surrounded
end

surrounder.delete = function(self, lines)
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
end

surrounder.replace = function(self, lines, surrounders)
	local start_str = lines[1]:sub(1, 1)
	if surrounders:exists(start_str) then
		local deleted = surrounders[start_str]:delete(lines)
		if deleted then
			return self:exec(deleted)
		end
	end
	return nil
end

local surrounders = {
	register = function(self, l, r)
		self[l] = surrounder:new({ l = l, r = r })
		keymap.set("i", l, ("%s%s<ESC>i"):format(l, r))
	end,
	exists = function(self, l)
		return vim.tbl_contains(vim.tbl_keys(self), l)
	end,
}
surrounders:register("(", ")")
surrounders:register("[", "]")
surrounders:register("{", "}")
surrounders:register("'", "'")
surrounders:register('"', '"')

local function surround_exec(input, lines)
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

local function correct_range(start_row, start_col, end_row, end_col)
	if start_row > end_row then
		local tmp = start_row
		start_row = end_row
		end_row = tmp
	end
	if start_col > end_col then
		local tmp = start_col
		start_col = end_col
		end_col = tmp
	end
	local end_line = api.nvim_buf_get_lines(0, end_row, end_row + 1, true)[1]
	if end_col > #end_line - 1 then
		end_col = #end_line - 1
	end
	return start_row, start_col, end_row, end_col
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
	local start_row, start_col, end_row, end_col = correct_range(get_range_fn())
	local lines = api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col + 1, {})
	local l = fn.getcharstr()
	if not surrounders:exists(l) then
		return
	end
	local surrounded = surround_exec(l, lines)
	--print(("start_row = %d, start_col = %d, end_row = %d, end_col = %d"):format(start_row, start_col, end_row, end_col))
	api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col + 1, surrounded)
end

local function issue_opfunc()
	_G.surround = surround
	setlocal.opfunc = "v:lua.surround"
	return "g@"
end

keymap.set("n", "sa", function()
	return issue_opfunc()
end, { expr = true })

keymap.set("x", "sa", function()
	surround(nil)
	api.nvim_feedkeys(termcodes("<ESC>"), "v", false)
	local start_pos = _getpos("v")
	api.nvim_win_set_cursor(fn.bufwinid(api.nvim_win_get_buf(0)), { start_pos.lnum, start_pos.col - 1 })
end)

keymap.set("x", "sd", function()
	local l = fn.getcharstr()
	if surrounders:exists(l) then
		local start_row, start_col, end_row, end_col = correct_range(get_visualed_range())
		local lines = api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col + 1, {})
		local deleted = surrounders[l]:delete(lines)
		if deleted then
			api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col + 1, deleted)
			local start_pos = _getpos("v")
			api.nvim_win_set_cursor(fn.bufwinid(api.nvim_win_get_buf(0)), { start_pos.lnum, start_pos.col - 1 })
		end
	end
	api.nvim_feedkeys(termcodes("<ESC>"), "v", false)
end)

keymap.set("x", "sr", function()
	local l = fn.getcharstr()
	if surrounders:exists(l) then
		local start_row, start_col, end_row, end_col = correct_range(get_visualed_range())
		local lines = api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col + 1, {})
		local replaced = surrounders[l]:replace(lines, surrounders)
		if replaced then
			api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col + 1, replaced)
			local start_pos = _getpos("v")
			api.nvim_win_set_cursor(fn.bufwinid(api.nvim_win_get_buf(0)), { start_pos.lnum, start_pos.col - 1 })
		end
	end
	api.nvim_feedkeys(termcodes("<ESC>"), "v", false)
end)

-- }}}

-- {{{ help
-- helpをvsplitで開く
api.nvim_create_user_command("Vhelp", function(opts)
	api.nvim_command("vertical help " .. opts.args)
end, {
	nargs = 1,
	complete = "help",
})
-- }}}

-- {{{ fold vimrc
local vimrc_dir = fn.fnamemodify(S.MYVIMRC, ":p:h")
api.nvim_create_augroup("fold-method", {})
api.nvim_create_autocmd({ "BufEnter" }, {
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
	if fn.isdirectory(dir) ~= 1 and (force or confirm_should_mkdir(dir)) then
		fn.mkdir(dir, "p")
	end
end
api.nvim_create_augroup("auto-mkdir", {})
api.nvim_create_autocmd("BufWritePre", {
	group = "auto-mkdir",
	pattern = "*",
	callback = function(args)
		auto_mkdir(fn.fnamemodify(args.file, ":p:h"), vim.v.cmdbang == 1)
	end,
})
-- }}}

-- {{{ keywordprg for lua-vimrc
api.nvim_create_augroup("lua-help", {})
api.nvim_create_autocmd("BufRead", {
	group = "lua-help",
	pattern = "*.lua",
	callback = function(_)
		setlocal.keywordprg = fn.exists(":Vhelp") and ":Vhelp" or ":help"
	end,
})
-- }}}

-- {{{ buffer
-- 再利用可能なバッファのテーブル
local buffer_cache_table = setmetatable({}, {
	__index = function(self, name) -- '変数[バッファ名]'でbufnr取得可能
		for bufnr, bufname in pairs(self) do
			if name == bufname then
				if api.nvim_buf_is_valid(bufnr) then
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
api.nvim_create_augroup("terminal", {})
api.nvim_create_autocmd({ "TermOpen" }, {
	group = "terminal",
	pattern = "*",
	callback = function(_)
		vim.cmd("startinsert")
	end,
})
api.nvim_create_autocmd({ "TermClose" }, {
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
		local winid = fn.bufwinid(before_open_term.bufnr)
		if winid == -1 then
			winid = open_split_win_with_buf(before_open_term.bufnr, before_open_term.direction or "v")
		end
		fn.win_gotoid(winid)
	end
end

keymap.set("n", terminal_key_prefix .. "x", function()
	toggle_term()
end, { silent = true })
local function register_keymaps_for_hide_term(bufnr)
	if not bufnr then
		error("arg 'bufnr' is required")
	end
	keymap.set("n", terminal_key_prefix .. "x", "<cmd>hide<CR>", { silent = true, buffer = bufnr })
end

local function get_terminal_buffer_list()
	local l = {}
	for _, bufnr in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
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
		local term_title = api.nvim_buf_get_var(bufnr, "term_title")
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
		bufnr = api.nvim_create_buf(true, false)
	end
	local winid = fn.bufwinid(bufnr)
	before_open_term = { bufnr = bufnr, direction = direction or "v" }
	if winid == -1 then
		winid = open_split_win_with_buf(bufnr, direction)
		if isNew then
			api.nvim_command("terminal")
			register_keymaps_for_hide_term(bufnr)
			return
		end
	end
	fn.win_gotoid(winid)
end

keymap.set("t", "<C-x>", [[<C-\><C-n>]])
keymap.set("n", terminal_key_prefix .. "v", function()
	open_terminal(false, "v")
end, { silent = true })
keymap.set("n", terminal_key_prefix .. "s", function()
	open_terminal(false, "s")
end, { silent = true })
keymap.set("n", terminal_key_prefix .. "t", ":tabnew +terminal<CR>", { silent = true })
-- }}}

-- {{{1 load plugins
local function load_plugins()
	local ok, modOrErr = pcall(require, "plugins")
	if not ok then
		print(modOrErr)
		return
	end
	local ok, err = pcall(modOrErr.initManager)
	if not ok then
		print(err)
		return
	end
	local ok, err = pcall(modOrErr.initSetup)
	if not ok then
		print(err)
		return
	end
end
load_plugins()
-- }}}

-- {{{1 lua
-- {{{2 luacheck
local luacheck = function(path)
	if fn.executable("luacheck") ~= 1 then
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
		local qflist_size = fn.getqflist({ size = 0 }).size
		if qflist_size == 1 then
			if fn.getqflist({ items = 0 }).items[1].text == "I/O error" then
				need_copen = false
				print(":make error")
			end
		elseif qflist_size == 0 then
			need_copen = false
		end
		-- TODO :cwindowに変える
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
	if fn.executable("stylua") ~= 1 then
		error("stylua is not installed")
	end
	local bufnr = fn.bufnr()
	local wins = {}
	for _, winid in ipairs(api.nvim_list_wins()) do
		local win_bufnr = api.nvim_win_get_buf(winid)
		if bufnr == win_bufnr then
			local row, col = unpack(api.nvim_win_get_cursor(winid))
			wins[winid] = { row = row, col = col }
		end
	end
	local joined = _join_buf_all_lines(fn.bufnr())
	local out = fn.system("stylua -", joined)
	if vim.v.shell_error ~= 0 then
		error(out)
	end
	local new_lines = vim.split(out, "\n")
	api.nvim_buf_set_lines(fn.bufnr(), 0, -1, true, new_lines)
	for winid, pos in pairs(wins) do
		api.nvim_win_set_cursor(winid, { pos.row, pos.col })
	end
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
		--api.nvim_buf_create_user_command(args.buf, "LuaCheck", function(opts)
		--	luacheck(opts.args)
		--end, {
		--	nargs = "?",
		--	complete = "file",
		--})
		--api.nvim_buf_create_user_command(args.buf, "LuaCheckCurrent", function()
		--	luacheck(fn.expand("%"))
		--end, {})
		--api.nvim_create_augroup("stylua", {})
		--api.nvim_create_autocmd("BufWritePre", {
		--	group = "stylua",
		--	pattern = "*.lua",
		--	callback = function()
		--		stylua()
		--	end,
		--})
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

api.nvim_create_augroup("lang", {})
api.nvim_create_autocmd("Filetype", {
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
	api.nvim_buf_create_user_command(0, "AtMake", function()
		api.nvim_command("cclose")
		setlocal.makeprg = atMakeT.makeprg
		api.nvim_command("make")
		if vim.tbl_isempty(fn.getqflist()) then
			print("AtMake: build ok")
		else
			api.nvim_command("copen")
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
api.nvim_create_augroup("atCoder", {})
api.nvim_create_autocmd("FileType", {
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
	local out = fn.system(test_cmd, input)
	print("AtTest: out -> " .. out)
end

local function register_keymaps_for_ac_test(test_cmd, bufnr)
	if not test_cmd or not bufnr then
		error("2 arguments required")
	end
	keymap.set("c", "w<CR>", function()
		local input = _join_buf_all_lines(bufnr)
		exec_ac_test(test_cmd, input)
	end, { silent = true, buffer = bufnr })
	keymap.set("n", "p", 'gg<S-v>G"+p', { buffer = bufnr })
end

local function create_or_reuse_ac_input_buffer(test_cmd)
	assert(test_cmd, "args 'test_cmd' is required")
	local bufname = string.format("AtTestInput[%s]", test_cmd)
	local bufnr = ac_input_buffers[bufname]
	if bufnr == -1 then
		-- init.luaを再読込した際にバッファ名が被るのを避ける
		local _bufnr = fn.bufnr(fn.bufnr(bufname))
		if fn.bufexists(_bufnr) == 1 then
			bufnr = _bufnr
		else
			bufnr = create_scratch_buffer()
			api.nvim_buf_set_name(bufnr, bufname)
			api.nvim_buf_set_lines(bufnr, 0, -1, true, { "##### Paste the input for testing #####" })
		end
		ac_input_buffers[bufnr] = bufname
	end
	return bufnr
end

local function find_test_cmd(test_cmd)
	if fn.executable(test_cmd) ~= 1 then
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
		api.nvim_command("AtMake")
		done = true
	end)
	return done
end

local function atTest()
	local test_cmd = fn.expand("%:p:r") .. ".out"
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
			local winid = fn.bufwinid(bufnr)
			if winid == -1 then
				winid = open_split_win_with_buf(bufnr, "v")
			end
			fn.win_gotoid(winid)
			api.nvim_win_set_cursor(winid, { 1, 0 })
		end
	end
end

api.nvim_create_user_command("AtTest", function()
	atTest()
end, {})
-- }}}

-- {{{lsp

-- check client capabilities
-- :lua =vim.lsp.get_active_clients()[1].server_capabilities

-- check handlers
-- :lua pp(vim.tlb_keys(vim.lsp.handlers))

-- experimental
local lsp = {}
function lsp:new(ft, config)
	return setmetatable({
		ft = ft,
		config = config,
	}, {
		__index = lsp,
	})
end
local lsp_settings = {}
local function register_lsp_settings(ft, config)
	local l = lsp:new(ft, config)
	table.insert(lsp_settings, l)
end
register_lsp_settings("lua", {
	name = "lua-language-server",
	cmd = {
		vim.fn.fnamemodify("/home/takei0107/ghq/github.com/takei0107/dotfiles/lsp/boot/lua.sh", ":p"),
	},
	root_dir = { ".stylua.toml", ".luacheckrc" },
	settings = {
		Lua = {},
	},
})
local function lsp_start(config)
	vim.lsp.start({
		name = config.name,
		cmd = config.cmd,
		root_dir = vim.fs.dirname(vim.fs.find(config.root_dir)[1]),
		settings = config.settings,
		on_attach = config.on_attach,
	})
	if vim.bo.omnifunc == "" then
		vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
	end
end
local lsp_ag_id = vim.api.nvim_create_augroup("lsp", {})
--for _, lsp_setting in ipairs(lsp_settings) do
--	vim.api.nvim_create_autocmd("FileType", {
--		group = lsp_ag_id,
--		pattern = lsp_setting.ft,
--		callback = function()
--			vim.diagnostic.config({
--				severity_sort = true,
--			})
--			lsp_start(lsp_setting.config)
--		end,
--	})
--end
local function stop_lsp_client(bufnr, name)
	if not bufnr then
		bufnr = fn.bufnr()
	end
	local filter = {
		bufnr = bufnr,
	}
	if name then
		filter[name] = name
	end
	local clients = vim.lsp.get_active_clients(filter)
	if vim.tbl_isempty(clients) then
		print(("lsp client doesn't attached. bufnr = %d"):format(bufnr))
		return
	end
	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id, true)
	end
end
api.nvim_create_user_command("LspStop", function()
	stop_lsp_client()
end, {})

-- TODO lspが動いているバッファローカルにしたい
--vim.api.nvim_create_autocmd("DiagnosticChanged", {
--	callback = function(args)
--		local diagnostics = args.data.diagnostics
--		local qflist = vim.diagnostic.toqflist(diagnostics)
--		-- severity -> line -> columnでqflistをソート
--		table.sort(qflist, function(t1, t2)
--			if vim.diagnostic.severity[t1.type] == vim.diagnostic.severity[t2.type] then
--				if t1.lnum == t2.lnum then
--					return t1.col < t2.col
--				else
--					return t1.lnum < t2.lnum
--				end
--			end
--			return vim.diagnostic.severity[t1.type] < vim.diagnostic.severity[t2.type]
--		end)
--		-- TODO setqflistのactionを考える
--		fn.setqflist(qflist, "r")
--		vim.cmd("cwindow")
--	end,
--})
-- }}}
