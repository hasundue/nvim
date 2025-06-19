pkgs:

let
  inherit (pkgs) nvim;

  neovim = with nvim.modules; nvim.compose [ core dev lua nix ];

  neovim-dev = pkgs.writeShellScriptBin "dev" ''
    nix run .#full-dev -- --clean --cmd "set rtp+=.,./after"
  '';
in
pkgs.mkShell {
  buildInputs = [
    neovim-dev
    neovim
  ];
}
