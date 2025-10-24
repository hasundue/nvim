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
