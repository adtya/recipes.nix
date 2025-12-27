{
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko?ref=latest";
    impermanence.url = "github:nix-community/impermanence?ref=master";
    lanzaboote.url = "github:nix-community/lanzaboote?ref=master";
    sops-nix.url = "github:Mic92/sops-nix?ref=master";
    deploy-rs.url = "github:serokell/deploy-rs?ref=master";
    treefmt-nix.url = "github:numtide/treefmt-nix?ref=main";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay?ref=master";
    smc-fonts.url = "gitlab:smc/smc-fonts-flake?ref=trunk";
    adtyaxyz.url = "github:adtya/adtya.xyz?ref=main";
    wiki.url = "github:adtya/wiki?ref=main";
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
          overlays = [ (import ./packages) ];
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

      devShells = forAllSystems (
        system:
        (import ./devshells.nix {
          pkgs = pkgsFor system;
          inherit (inputs) deploy-rs;
        })
      );

      packages = forAllSystems (
        system:
        (import ./packages.nix {
          pkgs = pkgsFor system;
          inherit (inputs) nixpkgs;
        })
      );

      nixosModules.default = import ./modules/nixos;
      homeManagerModules.default = import ./modules/home-manager;

      nixosConfigurations = {

      };

    };
}
