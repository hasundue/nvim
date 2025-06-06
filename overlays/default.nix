{ lib, incl, im-switch-nvim, ... }:

rec {
  default = lib.composeManyExtensions [
    mkneovim
    plugins
  ];
  mkneovim = import ./mkneovim.nix { inherit incl; };
  plugins = import ./plugins.nix { inherit im-switch-nvim; };
}
