{
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-trusted-substituters = [ "https://nix-community.cachix.org" ];
  };
  inputs = {
    disko.url = "github:nix-community/disko?ref=latest";
    impermanence.url = "github:nix-community/impermanence?ref=master";
    lanzaboote.url = "github:nix-community/lanzaboote?ref=master";
    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nixvim.url = "github:nix-community/nixvim?ref=main";
    smc-fonts.url = "gitlab:smc/smc-fonts-flake?ref=trunk";
    sops-nix.url = "github:Mic92/sops-nix?ref=master";
    treefmt-nix.url = "github:numtide/treefmt-nix?ref=main";

    adtyaxyz.url = "git+https://codeberg.org/adtya/adtya.xyz?ref=main";
    wiki.url = "git+https://codeberg.org/adtya/wiki?ref=main";
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      forAllSystems = lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      pkgsFor =
        system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ inputs.self.overlays.default ];
        };
      mkHost =
        hostname: system:
        lib.nixosSystem {
          inherit system;
          pkgs = pkgsFor system;
          specialArgs = { inherit inputs; };
          modules = [
            inputs.self.nixosModules.default
            (_: {
              nixpkgs.hostPlatform = system;
              xyz.adtya.recipes.hostinfo = { inherit hostname; };
            })
            ./hosts/shared
            ./hosts/${lib.strings.toLower hostname}
          ];
        };
    in
    {
      overlays.default = import ./overlays.nix;

      formatter = forAllSystems (
        system:
        (import ./formatter.nix {
          pkgs = pkgsFor system;
          inherit (inputs) treefmt-nix;
        })
      );

      checks = forAllSystems (
        system:
        (import ./checks.nix {
          pkgs = pkgsFor system;
          inherit (inputs) treefmt-nix self;
        })
      );

      devShells = forAllSystems (system: (import ./devshells.nix { pkgs = pkgsFor system; }));

      packages = forAllSystems (
        system:
        (import ./packages.nix {
          pkgs = pkgsFor system;
          nixvim' = inputs.nixvim.legacyPackages.${system};
        })
      );

      nixosModules.default = import ./modules;

      nixosConfigurations = lib.mapAttrs mkHost {
        Bifrost = "x86_64-linux";
        Gloria = "x86_64-linux";
        Skipper = "x86_64-linux";
        Thor = "x86_64-linux";
      };
    };
}
