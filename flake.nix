{
  description = "My Neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    incl.url = "github:divnix/incl";

    incline-nvim = {
      url = "github:b0o/incline.nvim";
      flake = false;
    };
    im-switch-nvim = {
      url = "github:drop-stones/im-switch.nvim";
      flake = false;
    };
  };

  outputs = { nixpkgs, incl, self, ... } @ inputs:
    let
      lib = builtins // nixpkgs.lib;
      forSystem = system: module: (import module) {
        inherit self;
        lib = lib // { inherit incl; };
        pkgs = nixpkgs.legacyPackages.${system};
        srcs = { inherit (inputs) incline-nvim im-switch-nvim; };
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
