require("my.lsp").setup("nil_ls", {
  settings = {
    nix = {
      flake = {
        autoArchive = true,
        autoEvalInputs = true,
      },
    },
    ["nil"] = {
      formatting = vim.fn.executable("nixpkgs-fmt") > 0 and {
        command = { "nixpkgs-fmt" },
      } or nil,
    },
  },
})

vim.opt.expandtab = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
