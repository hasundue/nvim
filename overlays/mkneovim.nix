{ incl, ... }:

final: prev:

let
  inherit (final) lib;

  compose = fs: e: lib.pipe e fs;

  removeSuffixAny = patterns:
    compose (map lib.removeSuffix patterns);

  normalizeName = compose [
    (lib.removePrefix "nvim-")
    (removeSuffixAny [ ".nvim" ".lua" "-nvim" ])
    (lib.replaceStrings [ "-" ] [ "_" ])
  ];

  luaConfigBase = (toString ../lua) + "/";

  getLuaConfigPath = drv:
    luaConfigBase + "plugins/${normalizeName drv.pname or drv.name}.lua";

  toLuaModuleSpec = compose [
    (lib.removePrefix luaConfigBase)
    (lib.removeSuffix ".lua")
  ];

  formatRequireLine = spec: ''require("${spec}")'';

  neovimConfig = final.neovimUtils.makeNeovimConfig { };
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

      configDir = incl ../. luaConfigs;

      modules = map
        toLuaModuleSpec
        (lib.filter lib.pathExists luaConfigs);

      requireLines = lib.concatLines (map formatRequireLine modules);

      packages = lib.concatLists (
        map (c: c.packages) configs
      );
    in
    final.wrapNeovimUnstable final.neovim-unwrapped (neovimConfig // {
      plugins = plugins';

      luaRcContent = ''
        vim.opt.runtimepath:append("${configDir}");
        ${requireLines}
      '';

      wrapperArgs = neovimConfig.wrapperArgs
        ++ [ "--suffix" "PATH" ":" (lib.makeBinPath packages) ];

      wrapRc = true; # make sure to wrap the rc file for `-u` option

      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
    });
}
