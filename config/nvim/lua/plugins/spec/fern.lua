---@class FloatOpts
---@field heightRatio number スクリーンの高さに対するフロートウィンドウの高さの比率(<1)
---@field widthRatio number スクリーンの幅に対するフロートウィンドウの幅の比率(<1)

--- スクラッチバッファ作成
---@return number bufnr
local function make_scratch_buf()
  return vim.api.nvim_create_buf(false, true)
end

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
    border = "single",
    height = float_win_height,
    width = float_win_width,
    row = float_win_row,
    col = float_win_col,
  }
end

--- フロートウィンドウを作成する。
---@param opts FloatOpts
local function make_float_win(opts)
  local buf = make_scratch_buf()
  assert(buf ~= 0, "nvim_create_buf() failed.")

  -- validate
  vim.validate({ opts = { opts, "table" } })
  vim.validate({
    ["opts.heightRatio"] = { opts.heightRatio, "n" },
    ["opts.widthRatio"] = { opts.widthRatio, "n" },
  })
  local function predicate(v)
    return v < 1
  end
  vim.validate({
    ["opts.heightRatio"] = { opts.heightRatio, predicate, "should be less than 1" },
    ["opts.widthRatio"] = { opts.widthRatio, predicate, "should be less than 1" },
  })

  -- create floating window
  local config = make_float_config(opts)
  return vim.api.nvim_open_win(buf, true, config)
end

--- フロートウィンドウのレイアウト設定
local function layout_floating_display(winId)
  vim.api.nvim_set_option_value("number", false, { win = winId })
  vim.api.nvim_set_option_value("relativenumber", false, { win = winId })
end

--- フロートで開いたfernにキーマップを設定する。
---@param before_win number フロートウィンドウを開く前のwinnr
---@param fernBuf number fernのbufnr
local function set_keymaps(before_win, fernBuf)
  -- 'q'でフロートウィンドウ閉じる
  vim.keymap.set("n", "q", "<cmd>close<cr>", {
    buffer = fernBuf,
  })

  -- fernでファイルを開いた後のフック
  -- fernで開いたバッファをフロートウィンドウを開く前のウィンドウにアタッチする。
  -- '<Plug>(fern-action-open:*)'の時点でfernが閉じfernローカルのキーマップは使えなくなるので擬似的なローカルマッピングを作る
  vim.keymap.set("n", "<Plug>(change-win-edit)", function()
    local bufnr = vim.fn.bufnr()
    vim.cmd("close")
    vim.api.nvim_win_set_buf(before_win, bufnr)
    vim.keymap.del("n", "<Plug>(change-win-edit)")
  end, {})

  -- <Plug>マッピング用オプション
  local opts = {
    buffer = fernBuf,
    remap = true,
  }

  vim.keymap.set("n", "<Plug>(fern-action-open)", "<Plug>(fern-action-open:edit)<Plug>(change-win-edit)", opts)
end

-- fernをフロートウィンドウで開く
---@paran パス
local function open_fern_floating(path)
  local called_win = vim.fn.win_getid()
  ---@type FloatOpts
  local opts = {
    heightRatio = 0.8,
    widthRatio = 0.8,
  }
  local float_win = make_float_win(opts)
  assert(float_win ~= 0, "make_float_win() failed.")
  vim.api.nvim_win_call(float_win, function()
    vim.cmd(string.format("Fern . -reveal=%s", path))
  end)
  layout_floating_display(float_win)
  local fernBuf = vim.api.nvim_win_get_buf(float_win)
  set_keymaps(called_win, fernBuf)
end

return {
  "lambdalisue/fern.vim",
  lazy = true,
  init = function()
    -- fern kemaps
    local fern_prefix = "<C-k>"
    vim.keymap.set("n", fern_prefix .. "k", "<Cmd>Fern . -reveal=% -opener=edit<CR>")
    vim.keymap.set("n", fern_prefix .. "f", function()
      local path = vim.fn.expand("%")
      open_fern_floating(path)
    end)

    -- fern variablse
    vim.g["fern#default_hidden"] = 1
    vim.g["fern#default_exclude"] = ".git"
  end,
  cmd = { "Fern", "FernDo" },
}
