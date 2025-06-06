{ incl }:


final: prev:

{
  lib = prev.lib // { inherit incl; };
}
