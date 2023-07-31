return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "j-hui/fidget.nvim",
  },
  ---FileTypeイベント(ft)だと、nvim-lspconfig読み込み後にバッファにlspをアタッチするautocmdが登録されるため、
  ---そのFileTypeイベントを発火させたファイルを再度読み込んでlspをアタッチさせる必要があるので、BufReadで遅延ロードする。
  ---BufRead -> lspconfigロード -> FileTypeイベント(autocmd登録) -> set ft -> FileTypeイベント発火 -> バッファにLSPアタッチ
  event = "BufRead *",
  config = function()
    local settings = require("lsp.settings")
    for ls_name, setting in pairs(settings) do
      require("lspconfig")[ls_name].setup(setting)
    end
    require("lsp.keymap").register()
  end,
}
