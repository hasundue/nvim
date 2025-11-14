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
      },
    },
  },
})
