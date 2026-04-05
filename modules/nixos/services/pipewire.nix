{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.services.pipewire;
  preset-cfg = config.xyz.adtya.recipes.presets;
in
{
  options = {
    xyz.adtya.recipes.services.pipewire = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.desktop;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
        description = "Enable Pipewire";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
    };
  };
}
