{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.services.geoclue;
  preset-cfg = config.xyz.adtya.recipes.presets;
in
{
  options = {
    xyz.adtya.recipes.services.geoclue = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.desktop;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
        description = "Enable Geoclue";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    location.provider = "geoclue2";
    services.geoclue2 = {
      enable = true;
      enable3G = false;
      enableCDMA = false;
      enableNmea = false;
      enableWifi = true;
      enableModemGPS = false;
      enableDemoAgent = false;
      geoProviderUrl = "https://beacondb.net/v1/geolocate";
    };
  };
}
