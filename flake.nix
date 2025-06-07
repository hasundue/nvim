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

      forSystem = op: system: op
        (import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        });

      forEachSystem = op: lib.genAttrs [ "x86_64-linux" ] (forSystem op);
    in
    {
      overlays = import ./overlays {
        inherit lib;
        inherit (inputs) incl im-switch-nvim;
      };

      packages = forEachSystem (pkgs:
        {
          default = pkgs.mkNeovim {
            modules = with pkgs.vimModules; [
              nix
            ];
            plugins = with pkgs.vimPlugins; [
              noice-nvim
            ];
          };
        });
    };
}
