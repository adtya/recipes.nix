{
  inputs = {
    disko.url = "github:nix-community/disko?ref=latest";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS?ref=development";
    lanzaboote.url = "github:nix-community/lanzaboote?ref=master";
    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    smc-fonts.url = "gitlab:smc/smc-fonts-flake?ref=trunk";
    sops-nix.url = "github:Mic92/sops-nix?ref=master";
    treefmt-nix.url = "github:numtide/treefmt-nix?ref=main";

    tranquil-pds.url = "git+https://tangled.org/tranquil.farm/tranquil-pds";

    adtyaxyz.url = "git+https://codeberg.org/adtya/adtya.xyz?ref=main";
    wiki.url = "git+https://codeberg.org/adtya/wiki?ref=main";
    the-power-button.url = "git+https://codeberg.org/adtya/the-power-button?ref=main";
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
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "1password-cli"
              "1password"
              "discord"
              "spotify"
              "steam"
              "steam-unwrapped"
              "xone-dongle-firmware"
            ];
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
      overlays.default = import ./overlays;

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

      packages = forAllSystems (system: (import ./packages.nix { pkgs = pkgsFor system; }));

      nixosModules.default = import ./modules;

      nixosConfigurations = lib.mapAttrs mkHost {
        Bifrost = "x86_64-linux";
        Gloria = "x86_64-linux";
        Gwen = "x86_64-linux";
        Skipper = "x86_64-linux";
        Thor = "x86_64-linux";
        Rico0 = "aarch64-linux";
        Rico1 = "aarch64-linux";
        Rico2 = "aarch64-linux";
      };
    };
}
