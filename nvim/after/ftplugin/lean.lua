require('my.lsp').setup('leanls', {
  cmd = { 'lake', 'serve' },
  filetypes = { 'lean' },
  root_markers = {
    'lakefile.lean',
    'lakefile.toml',
    'lean-toolchain',
    'leanpkg.toml',
    '.git',
  },
})
