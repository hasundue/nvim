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
          overlays = lib.attrValues self.overlays;
        });

      forEachSystem = op: lib.genAttrs
        [ "x86_64-linux" ]
        (forSystem op);

      scanDir = dir: lib.mapAttrs'
        (name: _: lib.nameValuePair
          (lib.removeSuffix ".lua" name)
          (lib.path.append dir name)
        )
        (builtins.readDir dir);

      makeNvimAttrs = pkgs: wrapperFlags: rec {
        wrap = import ./wrapper.nix pkgs wrapperFlags;
        modules = import ./modules.nix pkgs;

        configs = scanDir ./plugin;
        utils = scanDir ./lua/my;

        compose = modules: wrap (
          lib.zipAttrsWith
            (name: values: lib.concatLists values)
            modules
        );
      };
    in
    {
      apps = forEachSystem (pkgs:
        let
          nvim = pkgs.nvim-dev;
          system = pkgs.system;
        in
        {     
          full-dev = {
            type = "app";
            meta.description = "run packages.${system}.full in development mode";
            program = lib.getExe (nvim.compose (lib.attrValues nvim.modules));
          };
        });

      packages = forEachSystem (pkgs:
        let
          inherit (pkgs) nvim;
        in
        with nvim.modules;
          lib.mapAttrs 
            (name: mod: nvim.compose (
              if name == "core" then [ core ]
              else if name == "dev" then [ core dev ]
              else [ core dev mod ]
            ))
            nvim.modules
          // {
            default = nvim.compose [ core dev lua nix ];
            full = nvim.compose (lib.attrValues nvim.modules);
          }
      );

      devShells = forEachSystem (pkgs: 
        lib.mapAttrs 
          (name: neovim: pkgs.mkShell {
            buildInputs = [ neovim ];
          })
          self.packages.${pkgs.system}
        // 
        { default = import ./shell.nix pkgs; }
      );

      overlays = {
        default = final: prev: {
          nvim = makeNvimAttrs final { };

          vimPlugins = prev.vimPlugins //
            import ./plugins.nix prev {
              inherit (inputs) im-switch-nvim;
            };
        };
        dev = final: prev: {
          nvim-dev = makeNvimAttrs final { wrapLua = false; };
        };
      };
    };
}
