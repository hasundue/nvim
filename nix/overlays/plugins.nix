{ im-switch-nvim, ... }:

final: prev:

let
  buildVimPlugin = final.vimUtils.buildVimPlugin;
in
{
  vimPlugins = prev.vimPlugins // {
    im-switch-nvim =
      let
        src = im-switch-nvim;
      in
      buildVimPlugin {
        inherit src;

        pname = "im-switch-nvim";
        version = src.rev;

        dependencies = with final.vimPlugins; [
          plenary-nvim
        ];
      };
  };
}
