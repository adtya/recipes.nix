{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.boot.plymouth;
  preset-cfg = config.xyz.adtya.recipes.presets;
in
{
  options = {
    xyz.adtya.recipes.boot.plymouth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.desktop;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
        description = "Enable Plymouth";
      };
      theme = lib.mkOption {
        type = lib.types.str;
        default = "hexagon_dots";
        description = "One of the themes from [here](https://github.com/adi1090x/plymouth-themes)";
      };

    };
  };

  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      themePackages = lib.mkDefault [
        (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ cfg.theme ]; })
      ];
      theme = lib.mkDefault cfg.theme;
    };
  };
}
