require("my.lsp").setup("pyright")

require("my.lsp").setup("ruff", {
  settings = {
    configurationPreferences = "filesystemFirst",
  },
})

vim.opt.expandtab = false

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
