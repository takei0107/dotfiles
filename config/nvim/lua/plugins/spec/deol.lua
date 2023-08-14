local floatUtil = require("util.float")

local lazygit_bufnr = nil

---@param useTab boolean タブで開くかどうか
local function open_lazygit_buffer(useTab)
  -- 他のタブで開いていたらそのタブのウィンドウを開く
  if useTab then
    if lazygit_bufnr ~= nil and vim.api.nvim_buf_is_valid(lazygit_bufnr) then
      for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
          if vim.api.nvim_win_get_buf(win) == lazygit_bufnr then
            vim.api.nvim_set_current_tabpage(tabpage)
            vim.api.nvim_set_current_win(win)
            vim.cmd.startinsert()
            return
          end
        end
      end
    end
    vim.cmd.tabnew()
  end
  vim.cmd.Deol({ args = { "lazygit", "-start-insert", "-toggle" } })
  lazygit_bufnr = vim.fn.bufnr()

  local function lazygit_buf_autocmd()
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      group = vim.api.nvim_create_augroup("LazyBufEnter", {}),
      buffer = lazygit_bufnr,
      callback = function()
        if vim.fn.mode() ~= "t" then
          vim.cmd.startinsert()
        end
      end,
    })
  end

  local function lazygit_buf_keymap()
    local function lazygit_keymap(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = lazygit_bufnr })
    end
    lazygit_keymap("t", "<Left>", "<C-\\><C-n>gT")
    lazygit_keymap("t", "<Right>", "<C-\\><C-n>gt")
    lazygit_keymap({ "n", "t" }, "q", function()
      vim.cmd.quit({ bang = true })
      vim.api.nvim_buf_delete(lazygit_bufnr, { force = true })
      lazygit_bufnr = nil
    end)
  end

  lazygit_buf_autocmd()
  lazygit_buf_keymap()
end

return {
  "Shougo/deol.nvim",
  --enabled = false,
  keys = { "<C-t>" },
  cmd = { "Deol", "DeolEdit" },
  init = function()
    local shell = vim.fn.fnamemodify(vim.o.shell, ":p:t")
    if shell == "zsh" then
      vim.g["deol#prompt_pattern"] = "^.*[❯❮] " -- 対話シェルで使っているプロンプト文字列
    end
    vim.g["deol#floating_border"] = "single"
    local floatConfig = floatUtil.make_float_config({
      row = 1,
    })
    local cmd = "<cmd>Deol -split=floating -toggle -winheight=%d -winrow=%d -winwidth=%d -wincol=%d<CR>"
    vim.keymap.set("n", "<C-t>f", cmd:format(floatConfig.height, floatConfig.row, floatConfig.width, floatConfig.col))
    if vim.fn.executable("lazygit") == 1 then
      vim.keymap.set("n", "<C-t>l", function()
        open_lazygit_buffer(true)
      end)
    end
  end,
}
