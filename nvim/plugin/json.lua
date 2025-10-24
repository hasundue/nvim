vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc' },
  callback = function()
    require('my.lsp').setup('jsonls')
  end,
})

pcall(function()
  vim.treesitter.language.register('json', 'jsonc')
end)
