{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.services.dbus;
  desktop-cfg = config.xyz.adtya.recipes.presets.desktop;
in
{
  options = {
    xyz.adtya.recipes.services.dbus = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = desktop-cfg;
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
