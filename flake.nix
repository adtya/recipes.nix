{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix?ref=main";
  };
  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      forAllSystems = lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      pkgsFor =
        system:
        import inputs.nixpkgs {
          inherit system;
          overlays = [ (import ./overlay.nix) ];
        };
    in
    {
      formatter = forAllSystems (
        system:
        (import ./formatter.nix {
          pkgs = pkgsFor system;
          inherit (inputs) treefmt-nix;
        })
      );

      devShells = forAllSystems (system: (import ./devshells.nix { pkgs = pkgsFor system; }));

      packages = forAllSystems (system: (import ./packages.nix { pkgs = pkgsFor system; }));
      nixosModules.default = import ./modules;
      overlays.default = import ./overlay.nix;
    };
}
