{
  dev ? false,
  lib,
  neovimUtils,
  neovim-unwrapped,
  wrapNeovimUnstable,
  vimPlugins,
}:
let
  removePrefixAny = patterns: str: lib.pipe str (map lib.removePrefix patterns);
  removeSuffixAny = patterns: str: lib.pipe str (map lib.removeSuffix patterns);

  getLuaScriptName =
    drv:
    drv
    |> (drv: drv.pname or drv.name)
    |> removePrefixAny [
      "nvim-"
      "vim-"
      "vimplugin-treesitter-grammar-"
    ]
    |> removeSuffixAny [
      ".nvim"
      ".lua"
      "-nvim"
    ]
    |> lib.replaceStrings [ "-" "." ] [ "_" "_" ]
    |> (name: "${name}.lua");

  toFileSet = dir: map (drv: lib.fileset.maybeMissing (lib.path.append dir (getLuaScriptName drv)));

  neovimConfig = neovimUtils.makeNeovimConfig { };

  toWrapperArgs =
    flags:
    lib.foldl' (
      acc: flag:
      acc
      ++ [
        "--add-flags"
        flag
      ]
    ) [ ] flags;
in
{
  configs ? [ ], # [ Path ] (pkgs.mkNeovim.configs)
  filetypes ? [ ], # [ Derivation ] (pkgs.vimPlugins.nvim-treesitter-parsers)
  init ? [ ../nvim/init.lua ], # [ Path ]
  packages ? [ ], # [ Derivation ] (pkgs)
  plugins ? [ ], # [ Derivation ] (pkgs.vimPlugins)
  utils ? [ ], # [ Path ] (pkgs.mkNeovim.utils)
}:
let
  nvim-treesitter = (vimPlugins.nvim-treesitter.withPlugins (_: filetypes)).overrideAttrs (oldAttrs: {
    passthru.initLua = (oldAttrs.passthru.initLua or "") + ''
      require'nvim-treesitter'.setup {
        install_dir = '${builtins.head oldAttrs.passthru.dependencies}'
      }
    '';
  });
  plugins' = plugins ++ lib.optionals (filetypes != [ ]) [ nvim-treesitter ];
  rtp = lib.fileset.toSource {
    root = ../nvim;
    fileset = lib.fileset.unions (
      configs
      ++ utils
      ++ toFileSet ../nvim/after/ftplugin filetypes
      ++ toFileSet ../nvim/after/plugin plugins'
      ++ toFileSet ../nvim/plugin plugins'
    );
  };
in
wrapNeovimUnstable neovim-unwrapped (
  neovimConfig
  // {
    autoconfigure = true;
    autowrapRuntimeDeps = true;

    plugins = plugins';

    wrapperArgs =
      neovimConfig.wrapperArgs
      ++ toWrapperArgs (
        (
          if dev then
            [
              ''--cmd "lua vim.opt.rtp:append(vim.fn.getcwd() .. '/nvim')"''
              ''--cmd "lua vim.opt.rtp:append(vim.fn.getcwd() .. '/nvim/after')"''
            ]
            ++ lib.optionals (init != [ ]) [
              ''--cmd "execute 'source ' . getcwd() . '/nvim/init.lua'"''
            ]
          else
            [ ''--cmd "set rtp+=${rtp},${rtp}/after"'' ]
            ++ lib.optionals (init != [ ]) [
              ''--cmd "source ${builtins.head init}"''
            ]
        )
      )
      ++ lib.optionals (packages != [ ]) [
        "--suffix"
        "PATH"
        ":"
        (lib.makeBinPath packages)
      ];

    wrapRc = true; # make sure to wrap the rc file for `-u` option

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
  }
)
