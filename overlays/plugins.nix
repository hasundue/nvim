{
  im-switch-nvim,
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
  };
}
