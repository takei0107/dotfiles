---@type rc.Util
local util = require("util")

-- nvim in nvim
if os.getenv("NVIM") ~= nil then
  require("nvim-in-nvim").init(util)
  return
end

-- _G functions
_G.pp = function(arg)
  vim.print(arg)
end

_G.termcodes = function(key)
  return vim.api.nvim_replace_termcodes(key, true, true, true)
end

-- basic settings
---@module "rc.rtp"
util.safeRequireWithSideEffect("rc.rtp")
---@module "rc.options"
util.safeRequireWithSideEffect("rc.options")
---@module "rc.keymaps"
util.safeRequireWithSideEffect("rc.keymaps")
---@module "rc.commands"
util.safeRequireWithSideEffect("rc.commands")
---@module "rc.autocmd"
util.safeRequireWithSideEffect("rc.autocmd")

-- alias {{{
local set = vim.opt
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local S = vim.env
-- }}}

-- local functions
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

-- load plugins
---@module "load-plugins"
util.safeRequireWithSideEffect("load-plugins")
