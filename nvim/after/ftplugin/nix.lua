require('my.lsp').setup('nil_ls', {
  settings = {
    ['nil'] = {
      nix = {
        flake = {
          autoArchive = true,
          autoEvalInputs = true,
        },
      },
    },
  },
})
