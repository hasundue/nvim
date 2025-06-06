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
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in
      {
        packages = {
          default = pkgs.mkNeovim {
            plugins = with pkgs.vimPlugins; [
              kanagawa-nvim
            ];
          };
        };
      }
    ) // {
      overlays.default = import ./overlays/default.nix inputs;
    };
}
