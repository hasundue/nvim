require("core.lsp").setup("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

if vim.fn.executable("ruff") == 1 then
  require("core.lsp").setup("ruff", {
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
end
