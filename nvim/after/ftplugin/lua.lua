vim.opt.expandtab = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

require('my.lsp').setup('lua_ls', {
  settings = {
    Lua = {
      format = {
        enable = false, -- Use external formatter
      },
      runtime = {
        version = 'LuaJIT',
        path = {
          '?.lua',
          '?/init.lua',
        },
        pathStrict = true,
      },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('lua', true),
      },
    },
  },
})
