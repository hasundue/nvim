{ im-switch-nvim }:

final: prev:

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

        buildInputs = with final; [
          vimPlugins.plenary-nvim
        ];
      };
  };
}
