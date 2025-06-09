vim.lsp.config("ruff", {
  settings = {
    configurationPreferences = "filesystemFirst",
    fixAll = true,
    format = {
      preview = true,
    },
    lint = {
      enable = true,
      preview = true,
    },
    organizeImports = true,
  },
})
