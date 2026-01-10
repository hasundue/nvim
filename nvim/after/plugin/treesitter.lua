-- Highlighting
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'nix',
    'lua',
  },
  callback = function()
    vim.treesitter.start()
  end,
})

-- Indent
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- Folding
-- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.wo[0][0].foldmethod = 'expr'
