require('nvim-treesitter.configs').setup({
  auto_install = false,
  ensure_installed = {},
  highlight = {
    enable = true,
    disable = {},
  },
  ignore_install = {},
  indent = {
    enable = true,
    disable = {
      "nix",
    },
  },
  modules = {},
  sync_install = false,
})
