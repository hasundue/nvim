require("utils.lsp").setup("pyright", {
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
  require("lua.utils.lsp").setup("ruff", {
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
