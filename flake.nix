{
  description = "My Neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
        inherit (inputs) im-switch-nvim;
      };

      packages = forEachSystem (pkgs:
        {
          default = pkgs.mkNeovim {
            configs = with pkgs.neovimConfigs; [
              opt
            ];
            plugins = with pkgs.vimPlugins; [
              kanagawa-nvim
            ];
          };
        });
    };
}
