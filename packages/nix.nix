{ pkgs, ... }:

let
  inherit (pkgs) nvim;
in
nvim {
  config = with nvim.config; [
    nix
    lua
  ];
  plugins = with nvim.plugins; [
    avante
  ];
}
