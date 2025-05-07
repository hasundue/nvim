{ nixpkgs
, flake-utils
, nvim-flake
, ...
}:

{
  overlays = {
    default = final: prev: {
      mkNeovim = nvim-flake.${final.system};
    };
  };
} //
flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib;
    nvim = nvim-flake.${system};
  in
  rec {
    packages = with nvim.modules;
      {
        default = nvim { modules = all; };
      } //
      lib.mapAttrs
        (name: extra: nvim {
          modules = [ core clipboard copilot ] ++ extra;
        })
        {
          deno = [ deno ];
          nix = [ lua nix ];
          python = [ python ];
        };
    devShells = {
      default = pkgs.mkShell {
        packages = [ packages.nix ];
        shellHook = ''
          alias nv=nvim
        '';
      };
    };
  })
