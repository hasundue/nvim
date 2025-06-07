{ ... }:

final: prev:

let
  parsers = final.vimPlugins.nvim-treesitter-parsers;

  configs = {
    deno = {
      packages = with final; [
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
      packages = with final; [
        gopls
      ];
      plugins = with parsers; [
        go
        gomod
      ];
    };

    lua = {
      packages = with final; [
        lua-language-server
      ];
      plugins = with parsers; [
        luadoc
        toml
      ];
    };

    nix = {
      packages = with final; [
        nil
      ];
      plugins = with parsers; [
        nix
      ];
    };

    python = {
      packages = with final; [
        pyright
      ];
      plugins = with parsers; [
        python
        toml
      ];
    };

    rust = {
      packages = with final; [
        rust-analyzer
      ];
      plugins = with parsers; [
        rust
        toml
      ];
    };
  };
in
{
  vimConfigs = configs;
}

