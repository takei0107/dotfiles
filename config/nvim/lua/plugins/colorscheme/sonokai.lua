---@enum styles
local STYLES = {
  default = "default",
  atlantis = "atlantis",
  andromeda = "andromeda",
  shusia = "shusia",
  maia = "maia",
  espresso = "espresso",
}

local M = require("plugins.colorscheme.colorscheme").new({
  repo = "sainnhe/sonokai",
  schemeName = "sonokai",
  lazy = false,
  lazyPriority = 1000,
  transparent_enable = false,
  init = function()
    ---@type string
    vim.g.sonokai_style = STYLES.default
    ---@type integer
    vim.g.sonokai_better_performance = 1
    ---@type integer
    vim.g.sonokai_disable_italic_comment = 1
    ---@type integer
    vim.g.sonokai_dim_inactive_windows = 1

    -- lightlineでカラーテーマとして使ったりする
    vim.g.use_sonokai = true
  end,
})

return M
