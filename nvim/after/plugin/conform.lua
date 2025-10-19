require('conform').setup({
  formatters_by_ft = {
    ['*'] = function(bufnr)
      if require('conform').get_formatter_info('treefmt', bufnr).available then
        return { 'treefmt' }
      end
      return {}
    end,
  },
  formatters = {
    treefmt = {
      cwd = require('conform.util').root_file({ 'treefmt.toml', '.treefmt.toml', 'flake.nix' }),
    },
  },
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format({ bufnr = args.buf })
  end,
})
