vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc' },
  callback = function()
    require('my.lsp').setup('jsonls')
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})
