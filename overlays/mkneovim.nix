final: prev:

let
  inherit (final) lib neovimUtils wrapNeovimUnstable neovim-unwrapped;

  toLuaName = name: (lib.replaceStrings [ "-" ] [ "_" ] name);

  toLuaConfigPath = base: drv:
    (toString ../lua) + "/${base}/${toLuaName drv.pname}.lua";

  toLuaModuleSpec = base: drv:
    base + "." + (toLuaName drv.pname);

  formatRequireLine = path: ''require("${toLuaModuleSpec path}")'';

  neovimConfig = neovimUtils.makeNeovimConfig { };
in
{
  mkNeovim =
    { langs ? [ ]
    , plugins ? [ ]
    } @ attrs:
    let
      configs = lib.mapAttrsToList toLuaConfigPath attrs;
      configDir = lib.incl ../. configs;

      modules = lib.mapAttrsToList toLuaModuleSpec attrs;
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
