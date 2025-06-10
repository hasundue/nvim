{ pkgs, lib, ... }:

let
  p = pkgs.vimPlugins.nvim-treesitter-parsers;
in
lib.mapAttrs pkgs.mkNeovim {
  deno = {
    packages = with pkgs; [
      deno
    ];
    plugins = with p; [
      javascript
      jsdoc
      json
      jsonc
      tsx
      typescript
    ];
  };

  go = {
    packages = with pkgs; [
      gopls
    ];
    plugins = with p; [
      go
      gomod
    ];
  };

  lua = {
    packages = with pkgs; [
      lua-language-server
    ];
    plugins = with p; [
      luadoc
      toml
    ];
  };

  nix = {
    packages = with pkgs; [
      nil
    ];
    plugins = with p; [
      nix
    ];
  };

  python = {
    packages = with pkgs; [
      pyright
    ];
    plugins = with p; [
      python
      toml
    ];
  };

  rust = {
    packages = with pkgs; [
      rust-analyzer
    ];
    plugins = with p; [
      rust
      toml
    ];
  };
}
