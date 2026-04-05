{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.core.nix;
  nixDefaultSettings = {
    nix = {
      channel.enable = false;
      settings = {
        download-buffer-size = 1073741824;
        experimental-features = [
          "nix-command"
          "flakes"
          "auto-allocate-uids"
          "cgroups"
          "ca-derivations"
        ];
        auto-allocate-uids = true;
        sandbox = true;
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
in
{
  options = {
    xyz.adtya.recipes.core.nix = {
      auto-gc = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Automatic Garbage collection of the Nix store";
      };
      auto-optimise = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Automatic optimisation of the Nix store";
      };
    };
  };

  config = lib.mkMerge [
    nixDefaultSettings
    (lib.mkIf cfg.auto-gc nixGcSettings)
    (lib.mkIf cfg.auto-optimise nixOptimiseSettings)
  ];
}
