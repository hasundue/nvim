{ lib, ... }:

let
  composeTwo = f: g: x: f (g x);

  compose = lib.foldl' composeTwo lib.id;

  removeSuffixAny = patterns:
    compose (map lib.removeSuffix patterns);
in
{
  inherit
    compose
    removeSuffixAny;
}
