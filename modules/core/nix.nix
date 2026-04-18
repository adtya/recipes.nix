{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.core.nix;
  nixDefaultSettings = {
    nix = {
      channel.enable = false;
      settings = {
        auto-allocate-uids = true;
        download-buffer-size = 1073741824;
        experimental-features = [
          "nix-command"
          "flakes"
          "auto-allocate-uids"
          "cgroups"
          "ca-derivations"
        ];
        extra-substituters = [ "https://nix-community.cachix.org" ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        extra-trusted-substituters = [ "https://nix-community.cachix.org" ];
        sandbox = true;
        trusted-users = [ "@wheel" ];
        use-cgroups = true;
      };
    };
  };
  nixGcSettings = {
    nix.gc = {
      automatic = true;
      dates = "Fri *-*-* 00:00:00";
      options = "--delete-older-than 7d";
    };
  };
  nixOptimiseSettings = {
    nix.optimise = {
      automatic = true;
      dates = [ "Fri *-*-* 06:00:00" ];
    };
  };
  nhSettings = {
    xyz.adtya.recipes.core.nix.auto-gc = lib.mkForce false;
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 3";
    };
  };
in
{
  options = {
    xyz.adtya.recipes.core.nix = {
      auto-gc = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Automatic Garbage collection of the Nix store";
      };
      auto-optimise = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Automatic optimisation of the Nix store";
      };
      use-nh = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use NH for nixos-rebuild";
      };

    };
  };

  config = lib.mkMerge [
    nixDefaultSettings
    (lib.mkIf cfg.auto-gc nixGcSettings)
    (lib.mkIf cfg.auto-optimise nixOptimiseSettings)
    (lib.mkIf cfg.use-nh nhSettings)
  ];
}
