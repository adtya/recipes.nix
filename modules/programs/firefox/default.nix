{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.programs.firefox;
  preset-cfg = config.xyz.adtya.recipes.presets;
in
{
  options = {
    xyz.adtya.recipes.programs.firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.desktop;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
        description = "Enable Firefox";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      autoConfig = builtins.readFile ./prefs.cfg;
      policies = import ./policies.nix;
    };
  };
}
