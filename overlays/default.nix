{ lib, incl, im-switch-nvim, ... }:

rec {
  default = lib.composeManyExtensions [
    configs
    mkneovim
    plugins
  ];
  configs = import ./configs.nix { inherit incl; };
  mkneovim = import ./mkneovim.nix { inherit incl; };
  plugins = import ./plugins.nix { inherit im-switch-nvim; };
}
