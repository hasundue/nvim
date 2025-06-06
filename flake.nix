{
  description = "My Neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    incl.url = "github:divnix/incl";

    im-switch-nvim = {
      url = "github:drop-stones/im-switch.nvim";
      flake = false;
    };
  };

  outputs = { nixpkgs, self, ... } @ inputs:
    let
      lib = nixpkgs.lib;

      forSystem = system: op: op rec {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
        lib = pkgs.lib;
      };

      forEachSystem = op: lib.genAttrs [ "x86_64-linux" ] (sys: forSystem sys op);
    in
    {
      overlays.default = import ./overlays {
        inherit (nixpkgs) lib;
        inherit (inputs) incl im-switch-nvim;
      };

      packages = forEachSystem ({ pkgs, ... }:
        {
          default = pkgs.mkNeovim {
            plugins = with pkgs.vimPlugins; [
              im-switch-nvim
            ];
          };
        });
    };
}
