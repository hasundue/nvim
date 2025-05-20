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

  outputs = { nixpkgs, incl, self, ... } @ inputs:
    let
      lib = builtins // nixpkgs.lib // { inherit incl; };
      forSystem = system: module: (import module) {
        inherit self lib;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import ./nix/overlay.nix inputs) ];
        };
      };
    in
    lib.genAttrs [ "x86_64-linux" "aarch64-linux" ]
      (system:
        {
          __functor = self: (forSystem system ./nix/neovim.nix);
          modules =
            let
              attrs = forSystem system ./nix/modules.nix;
            in
            attrs // { all = lib.attrValues attrs; };
        }
      ) //
    (import ./nix/dogfood.nix (inputs // { nvim-flake = self; }));
}
