{
  dev ? false,
  lib,
  neovimUtils,
  neovim-unwrapped,
  wrapNeovimUnstable,
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
  packages ? [ ], # [ Derivation ] (pkgs)
  plugins ? [ ], # [ Derivation ] (pkgs.vimPlugins)
  utils ? [ ], # [ Path ] (pkgs.mkNeovim.utils)
}:
let
  rtp =
    if dev then
      "./nvim"
    else
      lib.fileset.toSource {
        root = ../nvim;
        fileset = lib.fileset.unions (
          configs
          ++ utils
          ++ toFileSet ../nvim/after/ftplugin filetypes
          ++ toFileSet ../nvim/after/plugin plugins
        );
      };
in
wrapNeovimUnstable neovim-unwrapped (
  neovimConfig
  // {
    plugins = plugins ++ filetypes;

    wrapperArgs =
      neovimConfig.wrapperArgs
      ++ toWrapperArgs [
        "--clean"
        ''--cmd "set rtp+=${rtp},${rtp}/after"''
      ]
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
