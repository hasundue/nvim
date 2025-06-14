require("core.lsp").setup("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.api.nvim_get_runtime_file("lua", true),
        },
      },
    },
  },
})
