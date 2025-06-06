{ incl }:

final: prev:

let
  inherit (final) lib;

  composeTwo = f: g: x: f (g x);

  compose = lib.foldl' composeTwo lib.id;

  removeSuffixAny = patterns:
    compose (map lib.removeSuffix patterns);
in
{
  lib = prev.lib // {
    inherit
      compose
      incl
      removeSuffixAny;
  };
}
