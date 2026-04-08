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
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      pkgsFor =
        system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ inputs.self.overlays.default ];
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

      checks = forAllSystems (
        system:
        (import ./checks.nix {
          pkgs = pkgsFor system;
          inherit (inputs) treefmt-nix self;
        })
      );

      devShells = forAllSystems (system: (import ./devshells.nix { pkgs = pkgsFor system; }));

      packages = forAllSystems (system: (import ./packages.nix { pkgs = pkgsFor system; }));

      overlays.default = import ./overlays;
      nixosModules.default = import ./modules/nixos;

      nixosConfigurations =
        let
          primary-user = {
            name = "adtya";
            long-name = "Adithya Nair";
            email = "adtya@adtya.xyz";
          };
        in
        {
          Gloria = lib.nixosSystem rec {
            system = "x86_64-linux";
            pkgs = pkgsFor system;
            specialArgs = { inherit inputs primary-user; };
            modules = [
              (_: { nixpkgs.hostPlatform = system; })
              ./hosts/shared
              ./hosts/gloria
            ];
          };
          Gwen = lib.nixosSystem rec {
            system = "x86_64-linux";
            pkgs = pkgsFor system;
            specialArgs = { inherit inputs primary-user; };
            modules = [
              (_: { nixpkgs.hostPlatform = system; })
              ./hosts/shared
              ./hosts/gwen
            ];
          };
          Skipper = lib.nixosSystem rec {
            system = "x86_64-linux";
            pkgs = pkgsFor system;
            specialArgs = { inherit inputs primary-user; };
            modules = [
              (_: { nixpkgs.hostPlatform = system; })
              ./hosts/shared
              ./hosts/skipper
            ];
          };
          Thor = lib.nixosSystem rec {
            system = "x86_64-linux";
            pkgs = pkgsFor system;
            specialArgs = { inherit inputs primary-user; };
            modules = [
              (_: { nixpkgs.hostPlatform = system; })
              ./hosts/shared
              ./hosts/thor
            ];
          };
          Bifrost = lib.nixosSystem rec {
            system = "x86_64-linux";
            pkgs = pkgsFor system;
            specialArgs = { inherit inputs primary-user; };
            modules = [
              (_: { nixpkgs.hostPlatform = system; })
              ./hosts/shared
              ./hosts/bifrost
            ];
          };
          Rico0 = lib.nixosSystem rec {
            system = "aarch64-linux";
            pkgs = pkgsFor system;
            specialArgs = { inherit inputs primary-user; };
            modules = [
              (_: { nixpkgs.hostPlatform = system; })
              ./hosts/shared
              ./hosts/rico0
            ];
          };
          Rico1 = lib.nixosSystem rec {
            system = "aarch64-linux";
            pkgs = pkgsFor system;
            specialArgs = { inherit inputs primary-user; };
            modules = [
              (_: { nixpkgs.hostPlatform = system; })
              ./hosts/shared
              ./hosts/rico1
            ];
          };
          Rico2 = lib.nixosSystem rec {
            system = "aarch64-linux";
            pkgs = pkgsFor system;
            specialArgs = { inherit inputs primary-user; };
            modules = [
              (_: { nixpkgs.hostPlatform = system; })
              ./hosts/shared
              ./hosts/rico2
            ];
          };
        };
    };
}
