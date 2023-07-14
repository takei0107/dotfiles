-- {{{ requires
---@type rc.Util
local util = require("util")
-- }}}

-- nvim in nvim {{{
if os.getenv("NVIM") ~= nil then
  require("nvim-in-nvim").init(util)
end
-- }}}

-- disable rtp plugins {{{
vim.g.loaded_remote_plugins = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_spellfile_plugin = 1
--- }}}

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
set.ignorecase = true
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
set.path:append(S.PWD .. "/**")
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

-- reload vimrc
keymap.set("n", "<F5>", function()
  local vimrc = S.MYVIMRC
  vim.cmd("luafile " .. vimrc)
  print(string.format("%s reloaded", vimrc))
end)

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

-- {{{1 commands

-- ":Of オプション名" で設定値表示
vim.cmd([[command! -nargs=1 -complete=option Of execute("echo &"..expand("<args>"))]])

-- helpをvsplitで開く
api.nvim_create_user_command("Vhelp", function(opts)
  api.nvim_command("vertical help " .. opts.args)
end, {
  nargs = 1,
  complete = "help",
})

-- {{{2 lua commands
local lua_ag_id = api.nvim_create_augroup("MyLuaCommand", {})
api.nvim_create_autocmd({ "FileType" }, {
  group = lua_ag_id,
  pattern = { "lua" },
  callback = function()
    -- luaの現在行をチャンクとして実行
    api.nvim_buf_create_user_command(0, "LuaExprLine", ".luado assert(loadstring(line))()", { nargs = 0 })
  end,
})
-- }}}
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

-- {{{ help
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

-- gitのcommitメッセージで開いた場合
--- @return boolean
local function isOnGitCommitMsg()
  for _, arg in ipairs(vim.v.argv) do
    if string.match(arg, "COMMIT_EDITMSG") then
      return true
    end
  end
  return false
end

-- lazy.nvimをmini modeで実行するかを判定する
---@return boolean
local function isUseMiniMode()
  return isOnGitCommitMsg()
end

-- プラグイン読み込み
local function load_plugins()
  ---@type boolean, rc.Util|string
  ---@param initializer rc.PluginsInitializer
  local _, err = util.safeRequire("plugins", function(initializer)
    initializer.initManager()
    initializer.initSetup(isUseMiniMode())
  end)
  if err then
    print("safeRequire() failed. error: " .. err)
  end
end
load_plugins()
-- }}}
