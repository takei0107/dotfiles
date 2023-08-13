---@type rc.Util
---@module"lua.util.init"
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
---@module "rc.terminal"
util.safeRequireWithSideEffect("rc.terminal")

-- {{{ fold vimrc
local vimrc_dir = vim.fn.fnamemodify(vim.env.MYVIMRC, ":p:h")
vim.api.nvim_create_augroup("fold-method", {})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = "fold-method",
  pattern = { vimrc_dir .. "/*.lua", vimrc_dir .. "/*/*.lua" },
  callback = function(_)
    vim.opt.foldmethod = "marker"
  end,
})
-- }}}

-- load plugins
---@module "load-plugins"
util.safeRequireWithSideEffect("load-plugins")

-- 画面透過
local function screen_transparent()
  ---@param module rc.Screen
  local _, err = util.safeRequire("util.screen", function(module)
    module.transparent()
  end)
  if err then
    print("safeRequire 'util.screen' failed")
  end
end
screen_transparent()

-- formatter
---@module "support.formatter"
util.safeRequireWithSideEffect("support.formatter")
