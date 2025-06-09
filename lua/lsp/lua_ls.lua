return {
  settings = {
    Lua = {
      hint = {
        enable = false,
      },
      runtime = {
        path = {
          "?.lua",
          "?/init.lua",
        },
        pathStrict = true,
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = vim.list_extend(
          vim.api.nvim_get_runtime_file("lua/*.lua", true),
          {
            "${3rd}/luv/library",
            -- "${3rd}/busted/library",
            -- "${3rd}/luassert/library",
          }),
      },
    },
  },
}
