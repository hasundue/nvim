inputs:

final: prev:

let
  lib = final.lib;

  wrapVimPlugin = name: args: final.vimUtils.buildVimPlugin ({
    pname = name;
    version = inputs.${name}.rev;
    src = inputs.${name};
  } // args);
in
{
  vimPlugins = prev.vimPlugins // {
    im-switch-nvim = wrapVimPlugin "im-switch-nvim" {
      buildInputs = with final; [
        vimPlugins.plenary-nvim
      ] ++ lib.optional hostPlatform.isWindows [
        cargo
      ];
    };
  };
}
