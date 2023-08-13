---@class rc.colorscheme
---@field repo string lazy.nvimで使うリポジトリ名
---@field schemeName string カラースキーム名
---@field lazyPriority integer|nil lazyの優先度 lazyのヘルプの'COLORSCHEMES'参照
---@field lazy boolean|nil デフォルト: false lazyが有効な場合は、`colorscheme {スキーマ名}`実行時にロードされる。
---@field config fun(self:LazyPlugin, opts:table)|boolean|nil
---@field init fun(self:LazyPlugin)|nil
---@field adjustor fun()|nil カラースキームの反映後にハイライトとかを調整するための関数
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
    adjustor = config.adjustor,
  }, {
    __index = colorscheme,
  })
end

function colorscheme:setup()
  vim.cmd.syntax("enable")
  vim.opt.termguicolors = true
  vim.cmd.colorscheme(self.schemeName)
  if self.adjustor then
    self.adjustor()
  end
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
