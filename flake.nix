{
  description = "My Neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    incl.url = "github:divnix/incl";

    im-switch-nvim = {
      url = "github:drop-stones/im-switch.nvim";
      flake = false;
    };
  };

  outputs = { nixpkgs, flake-utils, self, ... } @ inputs:
    let
      overlays = [
        (import ./overlays/lib.nix { inherit (inputs) incl; })
        (import ./overlays/plugins.nix { inherit (inputs) im-switch-nvim; })
        (import ./overlays/mkneovim.nix)
      ];
    in
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        packages = {
          default = pkgs.mkNeovim { };
        };
      });
}
