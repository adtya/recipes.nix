{
  lib,
  config,
  pkgs,
  ...
}:
let
  theme = "hexagon_dots";
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
    };
  };

  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      themePackages = lib.mkDefault [
        (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ theme ]; })
      ];
      theme = lib.mkDefault theme;
    };
  };
}
