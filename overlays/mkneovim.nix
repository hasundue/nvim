final: prev:

let
  inherit (final) lib;

  removeSuffixAny = patterns: str:
    lib.pipe str (map lib.removeSuffix patterns);

  getLuaConfigName = drv: lib.pipe drv [
    (drv: drv.pname or drv.name)
    (lib.removePrefix "nvim-")
    (removeSuffixAny [ ".nvim" ".lua" "-nvim" ])
    (lib.replaceStrings [ "-" ] [ "_" ])
  ];

  getLuaConfigPath = drv:
    ../lua + "/plugins/${getLuaConfigName drv}.lua";

  overridePlugin = drv:
    let
      luaConfigPath = getLuaConfigPath drv;
    in
    if lib.pathExists luaConfigPath then
      drv.overrideAttrs
        (prev: {
          passthru.initLua =
            lib.optionalString (prev.passthru ? initLua) prev.passthru.initLua
            + lib.readFile luaConfigPath;
        })
    else
      drv;

  luaLib = lib.fileset.toSource {
    root = ../.;
    fileset = ../lua/lib;
  };

  neovimConfig = final.neovimUtils.makeNeovimConfig { };
in
{
  mkNeovim =
    { configs ? [ ]
    , lsp ? [ ]
    , plugins ? [ ]
    , includeLib ? true
    }:
    let
      plugins' = lib.foldl' (ps: c: ps ++ c.plugins or [ ]) plugins configs;
      packages = lib.foldl' (ps: c: ps ++ c.packages or [ ]) [ ] configs;
      luaConfigs = map (c: c.luaConfig) configs;
    in
    final.wrapNeovimUnstable final.neovim-unwrapped (neovimConfig // {
      plugins = map overridePlugin plugins';

      luaRcContent = lib.optionalString includeLib ''
        vim.opt.runtimepath:append("${luaLib}");
      ''
      + lib.concatStringsSep "\n" (map lib.readFile luaConfigs);

      wrapperArgs = neovimConfig.wrapperArgs
        ++ lib.optionals (packages != [ ])
        [ "--suffix" "PATH" ":" (lib.makeBinPath packages) ];

      wrapRc = true; # make sure to wrap the rc file for `-u` option

      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
    });
}
