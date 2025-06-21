require('my.lsp').setup('denols', {
  settings = {
    deno = {
      enable = true,
      unstable = true,
    },
    typescript = {
      inlayHints = {
        enabled = 'on',
        functionLikeReturnTypes = { enabled = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
    },
  },
})

require('my.lsp').setup('ts_ls')

vim.opt.expandtab = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
