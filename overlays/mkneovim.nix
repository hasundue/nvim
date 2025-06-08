{ incl, ... }:

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

  toLuaModuleSpec = path: lib.pipe path [
    toString
    (lib.removePrefix (toString ../lua))
    (lib.removeSuffix ".lua")
  ];

  formatRequireLine = spec: ''require("${spec}")'';

  neovimConfig = final.neovimUtils.makeNeovimConfig { };

  overridePlugin = drv: 
    let
      luaConfigPath = getLuaConfigPath drv;
    in
    if lib.pathExists luaConfigPath then
      drv.overrideAttrs (prev: {
        passthru.initLua = lib.concatStringsSep "\n" (
          lib.optional (prev.passthru ? initLua) prev.passthru.initLua
          ++ [ (lib.readFile luaConfigPath) ]
        );
      })
    else
      drv;
in
{
  mkNeovim =
    { configs ? [ ]
    , plugins ? [ ]
    }:
    let
      plugins' = plugins ++ lib.concatLists (
        map (c: c.plugins) configs
      );

      luaConfigs = lib.concatLists [
        (map (c: c.luaConfig) configs)
        (map getLuaConfigPath plugins')
      ];

      configDir = incl ../. (luaConfigs ++ [ ../lua/utils ]);

      luaModules = map
        toLuaModuleSpec
        (lib.filter lib.pathExists luaConfigs);

      requireLines = lib.concatLines (map formatRequireLine luaModules);

      packages = lib.concatLists (
        map (c: c.packages) configs
      );
    in
    final.wrapNeovimUnstable final.neovim-unwrapped (neovimConfig // {
      plugins = map overridePlugin plugins';

      # luaRcContent = ''
      #   vim.opt.runtimepath:append("${configDir}");
      #   ${requireLines}
      # '';

      wrapperArgs = neovimConfig.wrapperArgs
        ++ [ "--suffix" "PATH" ":" (lib.makeBinPath packages) ];

      wrapRc = true; # make sure to wrap the rc file for `-u` option

      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
    });
}
