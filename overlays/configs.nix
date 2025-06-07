{ incl, ... }:

final: prev:

let
  lib = final.lib;

  parsers = final.vimPlugins.nvim-treesitter-parsers;

  configs = lib.pipe ../lua/configs [
    builtins.readDir
    lib.attrNames
    (map (lib.removeSuffix ".lua"))
  ];

  deps = {
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

  toVimConfig = name:
    {
      luaConfig = toString ../lua/configs + "/${name}.lua";
      packages =
        if lib.hasAttr name deps
        then deps.${name}.packages
        else [ ];
      plugins =
        if lib.hasAttr name deps
        then deps.${name}.plugins
        else [ ];
    };
in
{
  vimConfigs = lib.genAttrs configs toVimConfig;
}
