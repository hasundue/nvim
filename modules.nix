pkgs:

let
  cnfs = pkgs.nvim.configs;
  plgs = pkgs.vimPlugins;
  prss = plgs.nvim-treesitter-parsers;
  utls = pkgs.nvim.utils;
in
{
  core = {
    configs = with cnfs; [
      opt
    ];
    filetypes = with prss; [
      bash
      json
      markdown
      regex
      toml
      yaml
    ];
    plugins = with plgs; [
      gitsigns-nvim
      kanagawa-nvim
      lualine-nvim
      nvim-treesitter
      nvim-surround
    ];
  };

  dev = {
    configs = with cnfs; [
      clipboard
      lsp
      terminal
    ];
    plugins = with plgs; [
      blink-cmp
      codecompanion-nvim
      copilot-lua
      im-switch-nvim
      incline-nvim
      noice-nvim
      no-neck-pain-nvim
      nvim-lspconfig
      nvim-web-devicons
      oil-nvim
      telescope-nvim
      vim-floaterm
    ];
    utils = with utls; [
      lsp
    ];
  };

  deno = {
    filetypes = with prss; [
      javascript
      jsdoc
      json
      tsx
      typescript
    ];
  };

  go = {
    packages = with pkgs; [
      gopls
    ];
    filetypes = with prss; [
      go
      gomod
    ];
  };

  lua = {
    packages = with pkgs; [
      lua-language-server
    ];
    filetypes = with prss; [
      lua
      luadoc
    ];
  };

  nix = {
    packages = with pkgs; [
      nil
      nixpkgs-fmt
    ];
    filetypes = with prss; [
      nix
    ];
  };

  python = {
    packages = with pkgs; [
      pyright
    ];
    filetypes = with prss; [
      python
    ];
  };

  rust = {
    packages = with pkgs; [
      rust-analyzer
    ];
    filetypes = with prss; [
      rust
    ];
  };
}
