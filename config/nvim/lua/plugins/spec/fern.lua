---@module "util.init"
local util = require("util")

--- スクラッチバッファ作成
---@return number bufnr
local function make_scratch_buf()
  return vim.api.nvim_create_buf(false, true)
end


--- フロートウィンドウを作成する。
local function make_float_win()
  local buf = make_scratch_buf()
  assert(buf ~= 0, "nvim_create_buf() failed.")

  -- create floating window
  local float_config = util.make_float_config()
  return vim.api.nvim_open_win(buf, true, float_config)
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

  vim.keymap.set("n", "<Plug>(fern-action-rename)", "<Plug>(fern-action-rename:edit)", {
    buffer = fernBuf,
  })

  -- fernでファイルを開いた後のフック
  -- fernで開いたバッファをフロートウィンドウを開く前のウィンドウにアタッチする。
  -- '<Plug>(fern-action-open:*)'の時点でfernが閉じfernローカルのキーマップは使えなくなるので擬似的なローカルマッピングを作る
  vim.keymap.set("n", "<Plug>(change-win-edit)", function()
    local bufnr = vim.fn.bufnr()
    vim.cmd.close()
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
  ---@type FloatConfig
  local float_win = make_float_win()
  assert(float_win ~= 0, "make_float_win() failed.")
  vim.api.nvim_win_call(float_win, function()
    vim.cmd.Fern({ args = { ".", "-reveal=" .. path } })
  end)
  layout_floating_display(float_win)
  local fernBuf = vim.api.nvim_win_get_buf(float_win)
  set_keymaps(called_win, fernBuf)
end

--- fernの読み込み後に実行される関数群
--- fernのプラグインの初期化とかに使う
---@type fun()[]
local fern_loaded_hooks = {}

return {
  "lambdalisue/fern.vim",
  lazy = true,
  ---@type LazySpec[]
  dependencies = {
    {
      "lambdalisue/fern-git-status.vim",
      init = function()
        vim.g.loaded_fern_git_status = 1
        table.insert(fern_loaded_hooks, function()
          vim.cmd.unlet("g:loaded_fern_git_status")
          vim.fn["fern_git_status#init"]()
        end)
      end,
    },
  },
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
  config = function()
    for _, hook in ipairs(fern_loaded_hooks) do
      hook()
    end
  end,
}
