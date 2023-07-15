return {
  "lambdalisue/fern.vim",
  lazy = true,
  init = function()
    -- fern kemaps
    local fern_prefix = "<C-k>"
    vim.keymap.set("n", fern_prefix .. "f", "<Cmd>Fern . -reveal=% -opener=edit<CR>")

    -- fern variablse
    vim.g['fern#default_hidden'] = 1
    vim.g['fern#default_exclude'] = ".git"
  end,
  cmd = { "Fern", "FernDo" },
}
