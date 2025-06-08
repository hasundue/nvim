final: prev:

let
  lib = final.lib;

  configs = lib.pipe ../lua/configs [
    builtins.readDir
    lib.attrNames
    (map (lib.removeSuffix ".lua"))
  ];

  modules = import ../modules { pkgs = final; };

  toNeovimConfig = name:
    {
      luaConfig = ../lua/configs/${name}.lua;
    } // lib.optionalAttrs (lib.hasAttr name modules) {
      inherit (modules.${name}) packages plugins;
    };
in
{
  neovimConfigs = lib.genAttrs configs toNeovimConfig;
}
