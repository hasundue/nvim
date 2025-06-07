{ incl, ... }:

final: prev:

let
  inherit (final) lib;

  compose = fs: e: lib.pipe e fs;

  removeSuffixAny = patterns:
    compose (map lib.removeSuffix patterns);

  normalizePname = compose [
    (lib.removePrefix "nvim-")
    (removeSuffixAny [ ".nvim" ".lua" "-nvim" ])
    (lib.replaceStrings [ "-" ] [ "_" ])
  ];

  luaConfigBase = (toString ../lua) + "/";

  toLuaConfigPath = dir: drv:
    luaConfigBase + "${dir}/${normalizePname drv.pname}.lua";

  toLuaModuleSpec = compose [
    (lib.removePrefix luaConfigBase) 
    (lib.removeSuffix ".lua")
  ];

  formatRequireLine = spec: ''require("${spec}")'';

  neovimConfig = final.neovimUtils.makeNeovimConfig { };
in
{
  mkNeovim =
    { langs ? [ ]
    , plugins ? [ ]
    } @ attrs:
    let
      luaConfigs = lib.concatLists (
        lib.mapAttrsToList
          (key: drvs: lib.map (toLuaConfigPath key) drvs)
          attrs
      );
      configDir = incl ../. luaConfigs;

      modules = lib.map
        toLuaModuleSpec
        (lib.filter lib.pathExists luaConfigs);

      requireLines = lib.concatLines (map formatRequireLine modules);
    in
    final.wrapNeovimUnstable final.neovim-unwrapped (neovimConfig // {
      inherit plugins;

      luaRcContent = ''
        vim.opt.runtimepath:append("${configDir}");
        ${requireLines}
      '';

      wrapperArgs = neovimConfig.wrapperArgs;

      wrapRc = true; # make sure to wrap the rc file for `-u` option

      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
    });
}
