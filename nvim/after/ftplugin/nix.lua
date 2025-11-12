local hostname = vim.uv.os_gethostname()
local username = vim.uv.os_getenv('USER')

require('my.lsp').setup('nixd', {
  cmd = { 'nixd', '--log=error' },
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import <nixpkgs> { }',
      },
      options = {
        nixos = {
          expr = string.format(
            '(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.%s.options or {}',
            hostname,
            hostname
          ),
        },
        home_manager = {
          expr = string.format(
            '(builtins.getFlake (builtins.toString ./.)).homeConfigurations."%s@%s".options or {}',
            username,
            hostname
          ),
        },
      },
    },
  },
})
