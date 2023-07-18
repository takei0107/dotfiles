-- auto-mkdir
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
  if vim.fn.isdirectory(dir) ~= 1 and (force or confirm_should_mkdir(dir)) then
    vim.fn.mkdir(dir, "p")
  end
end
vim.api.nvim_create_augroup("auto-mkdir", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "auto-mkdir",
  pattern = "*",
  callback = function(args)
    auto_mkdir(vim.fn.fnamemodify(args.file, ":p:h"), vim.v.cmdbang == 1)
  end,
})

-- 挿入モードを抜ける際に日本語入力を終了する。
if vim.fn.executable("fcitx5-remote") == 1 then
  local id = vim.api.nvim_create_augroup("fcitx5", {})
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = id,
    callback = function(_)
      vim.system({ "fcitx5-remote", "-c" })
    end,
  })
end
