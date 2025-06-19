pkgs:

{ im-switch-nvim,
}:

let
  p = pkgs.vimPlugins;

  withPkgs = old: deps: old.overrideAttrs (oldAttrs: {
    runtimeDeps = (oldAttrs.runtimeDeps or [ ]) ++ deps;
  });

  withDeps = old: deps: old.overrideAttrs (oldAttrs: {
    dependencies = (oldAttrs.dependencies or [ ]) ++ deps;
  });
in
{
  im-switch-nvim =
    let
      src = im-switch-nvim;
    in
    pkgs.vimUtils.buildVimPlugin {
      inherit src;

      pname = "im-switch-nvim";
      version = src.rev;

      dependencies = with p; [
        plenary-nvim
      ];
    };

  noice-nvim = withDeps p.noice-nvim [
    p.nvim-notify
  ];

  copilot-lua = withPkgs p.copilot-lua [
    pkgs.nodejs
  ];

  telescope-nvim = withPkgs p.telescope-nvim [
    pkgs.fzf
    pkgs.ripgrep
  ];
}
