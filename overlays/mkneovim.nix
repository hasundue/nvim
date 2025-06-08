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
          passthru.initLua = lib.concatStringsSep "\n" (
            lib.optional (prev.passthru ? initLua) prev.passthru.initLua
            ++ [ (lib.readFile luaConfigPath) ]
          );
        })
    else
      drv;

  neovimConfig = final.neovimUtils.makeNeovimConfig { };
in
{
  mkNeovim =
    { configs ? [ ]
    , plugins ? [ ]
    }:
    let
      plugins' = plugins ++ lib.concatLists (
        map (c: c.plugins or [ ]) configs
      );

      luaConfigs = map (c: c.luaConfig) configs;

      packages = lib.concatLists (
        map (c: c.packages or [ ]) configs
      );
    in
    final.wrapNeovimUnstable final.neovim-unwrapped (neovimConfig // {
      plugins = map overridePlugin plugins';

      luaRcContent = lib.concatStringsSep "\n" (
        map lib.readFile luaConfigs
      );

      wrapperArgs = neovimConfig.wrapperArgs
        ++ [ "--suffix" "PATH" ":" (lib.makeBinPath packages) ];

      wrapRc = true; # make sure to wrap the rc file for `-u` option

      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
    });
}
