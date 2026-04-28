require('my.lsp').setup('leanls', {
  cmd = { 'lean', '--server' },
  filetypes = { 'lean' },
  root_markers = {
    'lakefile.lean',
    'lakefile.toml',
    'lean-toolchain',
    'leanpkg.toml',
    '.git',
  },
})
