require("utils.lsp").setup("rust_analyzer", {
  cmd = { "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        enable = false,
      }
    }
  }
})
