{
  im-switch-nvim,
  opencode-nvim,
  tree-sitter-lean,
  lean-nvim,
}:

final: prev:

let
  withRuntimeDeps =
    old: deps:
    old.overrideAttrs (oldAttrs: {
      runtimeDeps = (oldAttrs.runtimeDeps or [ ]) ++ deps;
    });

  withDependencies =
    old: deps:
    old.overrideAttrs (oldAttrs: {
      dependencies = (oldAttrs.dependencies or [ ]) ++ deps;
    });

  withInitLua =
    old: initLua:
    old.overrideAttrs (oldAttrs: {
      initLua = (oldAttrs.initLua or "") + "\n" + initLua;
    });
in
{
  vimPlugins = prev.vimPlugins // {
    im-switch-nvim =
      let
        src = im-switch-nvim;
      in
      final.vimUtils.buildVimPlugin {
        inherit src;

        pname = "im-switch-nvim";
        version = src.rev;

        dependencies = [
          final.vimPlugins.plenary-nvim
        ];
      };

    opencode-nvim =
      let
        src = opencode-nvim;
      in
      final.vimUtils.buildVimPlugin {
        inherit src;

        pname = "opencode-nvim";
        version = src.rev;

        dependencies = [
          final.vimPlugins.snacks-nvim
        ];

        runtimeDeps = [
          final.lsof
        ];
      };

    noice-nvim = withDependencies prev.vimPlugins.noice-nvim [
      final.vimPlugins.nvim-notify
    ];

    copilot-lua = withRuntimeDeps prev.vimPlugins.copilot-lua [
      final.nodejs
    ];

    telescope-nvim = withRuntimeDeps prev.vimPlugins.telescope-nvim [
      final.fzf
      final.ripgrep
    ];

    nvim-treesitter-parsers = prev.vimPlugins.nvim-treesitter-parsers // {
      lean = final.tree-sitter.buildGrammar {
        language = "lean";
        version = "unstable";
        src = final.runCommand "lean-grammar-src" { } ''
          cp -r ${tree-sitter-lean} $out
          chmod -R +w $out
          mkdir -p $out/queries/lean
          cp ${lean-nvim}/queries/lean/*.scm $out/queries/lean/
          # catch/try/finally nodes are unreachable in the parser
          sed -i '/^\[$/{N;/\n  "catch"/{N;N;N;d}}' $out/queries/lean/highlights.scm
        '';
        generate = true;
      };
    };
  };
}
