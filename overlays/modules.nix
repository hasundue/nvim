final: prev:

let
  lib = final.lib;

  configs = lib.pipe ../lua/configs [
    builtins.readDir
    lib.attrNames
    (map (lib.removeSuffix ".lua"))
  ];

  modules = import ../modules { pkgs = final; };

  toVimModule = name: attrs:
    {
      inherit (attrs) packages plugins;
      luaConfig = ../lua/configs + "/${name}.lua";
    };
in
{
  vimModules = lib.mapAttrs toVimModule modules;
}
