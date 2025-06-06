{ incl, im-switch-nvim, ... }:

final: prev:

final.lib.composeManyExtensions [
  (final.callPackage ../mkneovim.nix { })
  (final.callPackage ../plugins.nix { })
]
