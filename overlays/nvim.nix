{
  dev ? false,
}:

final: prev:

let
  inherit (final) lib;
  pkgs = final;

  wrapNeovim = pkgs.callPackage ../packages/wrapper.nix { inherit dev; };

  scanDir =
    dir:
    lib.mapAttrs' (
      name: _: lib.nameValuePair (lib.removeSuffix ".lua" name) (lib.path.append dir name)
    ) (builtins.readDir dir);

  c = scanDir ../nvim/plugin;
  u = scanDir ../nvim/lua/my;

  p = pkgs.vimPlugins;
  f = p.nvim-treesitter-parsers;

  extendAttrs =
    base: ext:
    let
      exts = if lib.isList ext then ext else [ ext ];
    in
    lib.zipAttrsWith (name: values: lib.concatLists values) ([ base ] ++ exts);

  makeExtendable =
    attrs:
    attrs
    // {
      extend = ext: wrapNeovim (extendAttrs attrs ext);
    };

  mkNvimAttr =
    { core, dev }@bases:
    exts: {
      nvim =
        makeExtendable { }
        // lib.mapAttrs (_: attrs: makeExtendable attrs) bases
        // {
          inherit exts;
          configs = c;
          utils = u;
          pkgs = lib.mapAttrs (_: ext: wrapNeovim (extendAttrs dev ext)) exts // {
            full = wrapNeovim (extendAttrs dev (lib.attrValues exts));
          };
        };
    };
in
mkNvimAttr
  rec {
    core = {
      configs = with c; [
        opt
      ];
      filetypes = with f; [
        bash
        json
        markdown
        regex
        toml
        yaml
      ];
      plugins = with p; [
        conform-nvim
        gitsigns-nvim
        kanagawa-nvim
        lualine-nvim
        nvim-lspconfig
        nvim-surround
        nvim-treesitter
      ];
      utils = with u; [
        lsp
      ];
    };

    dev = extendAttrs core {
      configs = with c; [
        clipboard
        lsp
        terminal
      ];
      plugins = with p; [
        blink-cmp
        codecompanion-nvim
        copilot-lua
        im-switch-nvim
        incline-nvim
        noice-nvim
        no-neck-pain-nvim
        nvim-spectre
        nvim-web-devicons
        oil-nvim
        telescope-nvim
        vim-floaterm
      ];
    };
  }
  {
    deno = {
      filetypes = with f; [
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
      filetypes = with f; [
        go
        gomod
      ];
    };

    lua = {
      packages = with pkgs; [
        lua-language-server
      ];
      filetypes = with f; [
        lua
        luadoc
      ];
    };

    nix = {
      packages = with pkgs; [ nil ];
      filetypes = with f; [ nix ];
    };

    python = {
      packages = with pkgs; [ pyright ];
      filetypes = with f; [ python ];
    };

    rust = {
      packages = with pkgs; [ rust-analyzer ];
      filetypes = with f; [ rust ];
    };
  }
