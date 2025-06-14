{ pkgs, lib, ... }:

let
  p = pkgs.vimPlugins.nvim-treesitter-parsers;
in
lib.mapAttrs pkgs.mkNeovim {
  deno = {
    ls = with pkgs; [
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
    ls = with pkgs; [
      gopls
    ];
    plugins = with p; [
      go
      gomod
    ];
  };

  lua = {
    ls = with pkgs; [
      lua-language-server
    ];
    plugins = with p; [
      luadoc
      toml
    ];
  };

  nix = {
    ls = with pkgs; [
      nil
    ];
    plugins = with p; [
      nix
    ];
  };

  python = {
    ls = with pkgs; [
      pyright
    ];
    plugins = with p; [
      python
      toml
    ];
  };

  rust = {
    ls = with pkgs; [
      rust-analyzer
    ];
    plugins = with p; [
      rust
      toml
    ];
  };
}
