require("utils.lsp").setup("denols", {
  cmd = { "deno", "lsp" },
  settings = {
    deno = {
      enable = true,
      unstable = true,
    },
    typescript = {
      inlayHints = {
        enabled = "on",
        functionLikeReturnTypes = { enabled = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
    },
  },
  single_file_support = true,
})
