{ incline-nvim, ... }:

final: prev:

let
  inherit (prev.vimUtils) buildVimPlugin;
in
{
  incline-nvim = buildVimPlugin {
    pname = "incline-nvim";
    version = incline-nvim.rev;
    src = incline-nvim;
  };
}
