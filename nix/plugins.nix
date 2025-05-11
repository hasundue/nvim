{ pkgs, lib, srcs, ... }:

pkgs.vimPlugins // (lib.mapAttrs
  (name: src: pkgs.vimUtils.buildVimPlugin {
    pname = name;
    version = src.rev;
    src = src;
  })
  srcs)
