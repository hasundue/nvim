require('my.lsp').setup('nil_ls', {
  settings = {
    nix = {
      flake = {
        autoArchive = true,
        autoEvalInputs = true,
      },
    },
  },
})

vim.opt.expandtab = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
