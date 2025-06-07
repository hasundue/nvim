{ lib, incl, im-switch-nvim, ... }:

rec {
  default = lib.composeManyExtensions [
    mkneovim
    modules
    plugins
  ];
  modules = import ./modules.nix;
  mkneovim = import ./mkneovim.nix { inherit incl; };
  plugins = import ./plugins.nix { inherit im-switch-nvim; };
}
