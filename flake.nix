{
  description = "My Neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    im-switch-nvim = {
      url = "github:drop-stones/im-switch.nvim";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, self, ... }@inputs:
    let
      lib = nixpkgs.lib;

      forSystem =
        op: system:
        op (
          import nixpkgs {
            inherit system;
            overlays = lib.attrValues self.overlays;
          }
        );

      forEachSystem = op: lib.genAttrs lib.systems.flakeExposed (forSystem op);

      nvimOverlay = import ./overlays/nvim.nix { };
      nvimDevOverlay = import ./overlays/nvim.nix { dev = true; };

      pluginsOverlay = import ./overlays/plugins.nix {
        inherit (inputs) im-switch-nvim;
      };
    in
    {
      packages = forEachSystem (pkgs: pkgs.nvim.pkgs);

      devShells = forEachSystem (
        pkgs:
        lib.mapAttrs (
          name: neovim:
          pkgs.mkShell {
            buildInputs = [ neovim ];
          }
        ) pkgs.nvim.pkgs
      );

      overlays = {
        default = lib.composeExtensions nvimOverlay pluginsOverlay;
        dev = lib.composeExtensions nvimDevOverlay pluginsOverlay;
      };
    };
}
