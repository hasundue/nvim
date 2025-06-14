return {
  cmd = { "nil" },
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
    nix = {
      flake = {
        autoArchive = true,
        autoEvalInputs = true,
      },
    },
  },
}
