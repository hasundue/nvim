{ nixpkgs
, flake-utils
, self
, ...
}:

{
  overlays = {
    default = final: prev: {
      mkNeovim = self.${final.system};
    };
  };
} //
flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
  let
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
    mkNeovim = self.${system};
  in
  rec {
    packages =
      {
        default = mkNeovim {
        };
      } //
      lib.mapAttrs
        (name: extra: mkNeovim {
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
