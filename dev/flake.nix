{
  description = "Development environment for hasundue/nvim";

  inputs = {
    git-hooks.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    nvim.url = "github:hasundue/nvim";
    nvim-dev.url = "path:..";
  };

  outputs =
    {
      git-hooks,
      nvim,
      nvim-dev,
      treefmt-nix,
      ...
    }:
    let
      nixpkgs = nvim-dev.inputs.nixpkgs;
      inherit (nixpkgs) lib;
      forEachSystem = lib.genAttrs nvim-dev.lib.supportedSystems;
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
          neovim = with pkgs.nvim.exts; pkgs.nvim.dev.extend [ lua ];
          treefmt = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build.wrapper;
          pre-commit = git-hooks.lib.${system}.run {
            src = ../.;
            hooks = {
              treefmt = {
                enable = true;
                package = treefmt;
              };
            };
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              neovim
              nil
              treefmt
            ];
            shellHook = lib.concatLines [
              pre-commit.shellHook
            ];
          };
        }
      );
    };
}
