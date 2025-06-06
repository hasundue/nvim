{ lib, incl, im-switch-nvim, ... }:

lib.composeManyExtensions [
  (import ./mkneovim.nix { inherit incl; })
  (import ./plugins.nix { inherit im-switch-nvim; })
]
