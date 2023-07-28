---@class rc.colorscheme
---@field repo string lazy.nvimで使うリポジトリ名
---@field schemeName string カラースキーム名
---@field lazyPriority integer|nil lazyの優先度 lazyのヘルプの'COLORSCHEMES'参照
---@field lazy boolean デフォルト: false lazyが有効な場合は、`colorscheme {スキーマ名}`実行時にロードされる。
---@field config fun(self:LazyPlugin, opts:table)|boolean|nil
---@field init fun(self:LazyPlugin)|nil
---
-- 'lazy'がtrueかつ、'skipSetup'がtrue以外の時
-- ':colorscheme {schemeName}'がsetupメソッドで実行されるタイミングで
-- 対象のカラースキームのプラグインがlazyによってロードされる。
--
-- カラースキームの中にはプラグイン内でカラースキームの指定をしている場合があるので
-- その場合は、'skipSetup'をtrueに設定し、'config'を設定した上で、
-- lazyの読み込み時にプラグインが提供している初期化手順を実行する。
--
local colorscheme = {}

---@param config rc.colorscheme
---@return rc.colorscheme
colorscheme.new = function(config)
  return setmetatable({
    repo = config.repo,
    schemeName = config.schemeName,
    lazyPriority = config.lazyPriority,
    lazy = config.lazy or false,
    config = config.config,
    init = config.init,
  }, {
    __index = colorscheme,
  })
end

function colorscheme:setup()
  vim.cmd.syntax("enable")
  vim.opt.termguicolors = true
  vim.cmd.colorscheme(self.schemeName)
end

---@return LazySpec
function colorscheme:toLazySpec()
  ---@type LazySpec
  return {
    [1] = self.repo,
    priority = self.lazyPriority,
    lazy = self.lazy,
    config = self.config,
    init = self.init,
  }
end

return colorscheme
