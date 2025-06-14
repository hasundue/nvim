{ lib, im-switch-nvim, ... }:

rec {
  default = lib.composeManyExtensions [
    mkneovim
    configs
    plugins
  ];
  configs = import ./configs.nix;
  mkneovim = import ./mkneovim.nix;
  plugins = import ./plugins.nix { inherit im-switch-nvim; };
}
