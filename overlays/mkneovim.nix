final: prev:

let
  inherit (final) lib neovimUtils wrapNeovimUnstable neovim-unwrapped;

  normalizePname = lib.compose [
    (lib.removePrefix "nvim-")
    (lib.removeSuffixAny [ ".nvim" ".lua" "-nvim" ])
    (lib.replaceStrings [ "_" ] [ "-" ])
  ];

  toLuaConfigPath = base: drv:
    (toString ../lua) + "/${base}/${normalizePname drv.pname}.lua";

  toLuaModuleSpec = path:
    lib.removePrefix ((toString ../lua) + "/") (lib.removeSuffix ".lua" path);


  formatRequireLine = spec: ''require("${spec}")'';

  neovimConfig = neovimUtils.makeNeovimConfig { };
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
      configDir = lib.incl ../. luaConfigs;

      modules = lib.map
        toLuaModuleSpec
        (lib.filter lib.pathExists luaConfigs);

      requireLines = lib.concatLines (map formatRequireLine modules);
    in
    wrapNeovimUnstable neovim-unwrapped (neovimConfig // {
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
