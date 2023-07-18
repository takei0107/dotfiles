--- スクリーンの属性を返す
---@return number 高さ,number 幅
local function get_screen_attrs()
  local height = vim.api.nvim_get_option_value("lines", {})
  local width = vim.api.nvim_get_option_value("columns", {})
  return height, width
end

--- フロートウィンドウ作成用のコンフィグを作成する
---@param opts FloatOpts
local function make_float_config(opts)
  -- screen position
  local screen_height, screen_width = get_screen_attrs()
  local float_win_height = math.floor(screen_height * opts.heightRatio)
  local float_win_width = math.floor(screen_width * opts.widthRatio)
  local float_win_row = (screen_height - float_win_height) / 2
  local float_win_col = (screen_width - float_win_width) / 2
  return {
    relative = "editor",
    anchor = "NW",
    border = "solid",
    height = float_win_height,
    width = float_win_width,
    row = float_win_row,
    col = float_win_col,
  }
end

---@param isNewTab boolean 新しいタブで開くかどうか
local function create_lazygit_buffer(isNewTab)
  if isNewTab then
    vim.cmd("tabnew")
  end
  vim.cmd("Deol lazygit -start-insert -toggle")
end

return {
  "Shougo/deol.nvim",
  --enabled = false,
  config = function()
    local shell = vim.fn.fnamemodify(vim.o.shell, ":p:t")
    if shell == 'zsh' then
      vim.g["deol#prompt_pattern"] = "❯ " -- 対話シェルで使っているプロンプト文字列
    end
    vim.g["deol#floating_border"] = "single"
    local floatConfig = make_float_config({
      widthRatio = 0.8,
      heightRatio = 0.8,
    })
    local cmd = "<cmd>Deol -edit -split=floating -toggle -winheight=%d -winrow=%d -winwidth=%d -wincol=%d<CR>"
    vim.keymap.set("n", "<C-t>f", cmd:format(floatConfig.height, floatConfig.row, floatConfig.width, floatConfig.col))
    if vim.fn.executable("lazygit") == 1 then
      vim.keymap.set("n", "<C-t>l", function()
        create_lazygit_buffer(true)
      end)
    end
  end,
}
