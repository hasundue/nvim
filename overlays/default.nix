{ lib, incl, im-switch-nvim, ... }:

rec {
  default = lib.composeManyExtensions [
    mkneovim
    plugins
  ];
  configs = import ./configs.nix { };
  mkneovim = import ./mkneovim.nix { inherit incl; };
  plugins = import ./plugins.nix { inherit im-switch-nvim; };
}
