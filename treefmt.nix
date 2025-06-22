_: {
  projectRootFile = "flake.nix";
  programs = {
    deadnix = {
      enable = true;
      no-lambda-pattern-names = true;
    };
    statix.enable = true;
    nixfmt = {
      enable = true;
      strict = true;
    };
    yamlfmt.enable = true;
  };
  settings.global = {
    excludes = [
      ".envrc"
      "LICENSE"
      "README.md"
      "*.png"
      "*/go.mod"
      "*/go.sum"
    ];
  };
}
