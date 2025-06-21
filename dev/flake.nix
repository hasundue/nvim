{
  description = "Development environment for hasundue/nvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    # nvim.url = "github:hasundue/nvim";
    nvim.url = "path:..";
    nvim-dev.url = "path:..";
  };

  outputs =
    {
      nixpkgs,
      nvim,
      nvim-dev,
      treefmt-nix,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      forEachSystem = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      apps = forEachSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nvim-dev.overlays.dev ];
          };
        in
        {
          default = {
            type = "app";
            meta.description = "Run Neovim in development mode";
            program = lib.getExe pkgs.nvim.pkgs.full;
          };
        }
      );
      devShells = forEachSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nvim.overlays.default ];
          };
          neovim =
            with pkgs.nvim.exts;
            pkgs.nvim.dev.extend [
              lua
              nix
            ];
          treefmt = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              neovim
              treefmt.config.build.wrapper
            ];
          };
        }
      );
    };
}
