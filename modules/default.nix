{ pkgs, ... }:

let
  parsers = pkgs.vimPlugins.nvim-treesitter-parsers;
in
{
  deno = {
    packages = with pkgs; [
      deno
    ];
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
    packages = with pkgs; [
      gopls
    ];
    plugins = with parsers; [
      go
      gomod
    ];
  };

  lua = {
    packages = with pkgs; [
      lua-language-server
    ];
    plugins = with parsers; [
      luadoc
      toml
    ];
  };

  nix = {
    packages = with pkgs; [
      nil
    ];
    plugins = with parsers; [
      nix
    ];
  };

  python = {
    packages = with pkgs; [
      pyright
    ];
    plugins = with parsers; [
      python
      toml
    ];
  };

  rust = {
    packages = with pkgs; [
      rust-analyzer
    ];
    plugins = with parsers; [
      rust
      toml
    ];
  };
}
