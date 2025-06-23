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
            overlays = [ self.overlays.default ];
          }
        );

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forEachSystem = op: lib.genAttrs supportedSystems (forSystem op);

      mkOverlay =
        opts:
        lib.composeManyExtensions [
          (import ./overlays/nvim.nix opts)
          (import ./overlays/plugins.nix { inherit (inputs) im-switch-nvim; })
        ];
    in
    {
      devShells = forEachSystem (
        pkgs:
        lib.mapAttrs (
          name: neovim:
          pkgs.mkShell {
            buildInputs = [ neovim ];
          }
        ) pkgs.nvim.pkgs
      );

      lib = { inherit supportedSystems; };

      overlays = {
        default = mkOverlay { };
        dev = mkOverlay { dev = true; };
      };

      packages = forEachSystem (pkgs: pkgs.nvim.pkgs);
    };
}
