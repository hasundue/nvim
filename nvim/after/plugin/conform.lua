require('conform').setup(vim.fn.executable('treefmt') > 0 and {
  formatters_by_ft = {
    ['*'] = { 'treefmt' },
  },
} or {})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format({ bufnr = args.buf })
  end,
})
