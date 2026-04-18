{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.services.dbus;
  preset-cfg = config.xyz.adtya.recipes.presets;
in
{
  options = {
    xyz.adtya.recipes.services.dbus = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.desktop;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
        description = "Enable DBus";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.dbus = {
      enable = true;
      packages = with pkgs; [
        gcr
        gcr_4
      ];
      implementation = "broker";
    };
  };
}
