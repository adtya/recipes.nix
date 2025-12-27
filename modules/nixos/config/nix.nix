{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.nix;
  nixDefaultSettings = {
    nix = {
      channel.enable = false;
      settings = {
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
  config = lib.mkMerge [
    nixDefaultSettings
    (lib.mkIf cfg.auto-gc nixGcSettings)
    (lib.mkIf cfg.auto-optimise nixOptimiseSettings)
  ];
}
