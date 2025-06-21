require('no-neck-pain').setup({
  width = 108,
})

vim.api.nvim_create_autocmd('BufRead', {
  pattern = { '*' },
  callback = function()
    vim.cmd('NoNeckPain')
  end,
  once = true,
})
