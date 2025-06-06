{ pkgs, ... }:

let
  plugins = pkgs.vimPlugins;
  parsers = plugins.nvim-treesitter-parsers;
in
{
  core = {
    config = ../lua/core;

    packages = with pkgs; [
      fd
      git
      lazygit
      ripgrep
    ];

    plugins = with plugins; [
      # colorscheme
      kanagawa-nvim

      # libraries
      nui-nvim
      nvim-notify
      nvim-web-devicons
      plenary-nvim

      # ui
      gitsigns-nvim
      im-switch-nvim
      incline-nvim
      lualine-nvim
      oil-nvim
      noice-nvim
      no-neck-pain-nvim
      telescope-nvim
      vim-floaterm

      # cmp
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-path
      cmp-snippy
      nvim-cmp
      nvim-snippy

      # lsp
      nvim-lspconfig

      # treesitter
      nvim-treesitter

      # utils
      vim-sandwich
    ];
  };

  clipboard.config = ../lua/feat/clipboard.lua;

  avante = {
    config = ../lua/feat/avante.lua;
    plugins = with plugins; [
      avante-nvim
      img-clip-nvim
    ];
  };

  copilot = {
    config = ../lua/feat/copilot.lua;
    packages = with pkgs; [
      nodejs
    ];
    plugins = with plugins; [
      copilot-lua
    ];
  };

  deno = {
    config = ../lua/lang/deno.lua;
    packages = with pkgs; [ deno ];
    plugins = with parsers; [
      javascript
      jsdoc
      json
      jsonc
      tsx
      typescript
    ];
  };

  go = {
    config = ../lua/lang/go.lua;
    packages = with pkgs; [
      go
      gopls
    ];
    plugins = with parsers; [
      go
      gomod
    ];
  };

  lua = {
    config = ../lua/lang/lua.lua;
    packages = with pkgs; [
      lua-language-server
    ];
    plugins = with parsers; [
      luadoc
    ];
  };

  nix = {
    config = ../lua/lang/nix.lua;
    packages = with pkgs; [
      nil
      nixpkgs-fmt
    ];
    plugins = with parsers; [
      nix
    ];
  };

  python = {
    config = ../lua/lang/python.lua;
    packages = with pkgs; [
      pyright
    ];
    plugins = with parsers; [
      python
    ];
  };

  rust = {
    config = ../lua/lang/rust.lua;
    packages = with pkgs; [
      rustup
      rust-analyzer
      rustfmt
    ];
    plugins = with parsers; [
      rust
      toml
    ];
  };
}
