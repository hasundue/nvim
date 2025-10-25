{
  dev ? false,
}:

final: prev:

let
  inherit (final) lib;
  pkgs = final;

  wrapNeovim = pkgs.callPackage ../pkgs/wrapper.nix { inherit dev; };

  scanDir =
    dir:
    lib.mapAttrs' (
      name: _: lib.nameValuePair (lib.removeSuffix ".lua" name) (lib.path.append dir name)
    ) (builtins.readDir dir);

  configs = scanDir ../nvim/plugin;
  utils = scanDir ../nvim/lua/my;

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
          inherit exts configs utils;
          pkgs = lib.mapAttrs (_: ext: wrapNeovim (extendAttrs dev ext)) exts // {
            default = wrapNeovim dev;
            full = wrapNeovim (extendAttrs dev (lib.attrValues exts));
          };
        };
    };
in
mkNvimAttr
  rec {
    core = {
      configs = with configs; [
        opt
      ];
      filetypes = with f; [
        bash
        json
        jsonc
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
      utils = with utils; [
        lsp
      ];
    };

    dev = extendAttrs core {
      configs = with configs; [
        clipboard
        json
        location
        lsp
        # terminal
      ];
      packages = with pkgs; [
        vscode-json-languageserver
      ];
      plugins = with p; [
        blink-cmp
        opencode-nvim
        copilot-lua
        im-switch-nvim
        incline-nvim
        noice-nvim
        # no-neck-pain-nvim
        nvim-spectre
        nvim-web-devicons
        oil-nvim
        plenary-nvim
        telescope-nvim
        # vim-floaterm
      ];
      filetypes = with f; [
        editorconfig
        nix
      ];
    };
  }
  {
    claude-code = {
      plugins = with p; [
        claude-code-nvim
      ];
    };

    codecompanion = {
      plugins = with p; [
        codecompanion-nvim
      ];
    };

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
      filetypes = with f; [
        go
        gomod
      ];
    };

    lua = {
      filetypes = with f; [
        lua
        luadoc
      ];
    };

    python = {
      filetypes = with f; [ python ];
    };

    rust = {
      filetypes = with f; [ rust ];
    };

    c = {
      filetypes = with f; [ c ];
    };

    cpp = {
      filetypes = with f; [ cpp ];
    };

    zig = {
      filetypes = with f; [ zig ];
    };

    terraform = {
      filetypes = with f; [
        hcl
        terraform
      ];
      packages = with pkgs; [
        terraform-ls
        tflint
      ];
    };
  }
