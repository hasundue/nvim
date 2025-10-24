require('my.lsp').setup('pyright')

require('my.lsp').setup('ruff', {
  settings = {
    configurationPreferences = 'filesystemFirst',
  },
})
