{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.networking;
  desktop-cfg = config.xyz.adtya.recipes.presets.desktop;
  wifiConfig = {
    networking = {
      networkmanager = {
        wifi = {
          backend = "iwd";
          powersave = false;
        };
      };
      wireless.iwd = {
        enable = true;
        settings = {
          General = {
            AddressRandomization = "network";
            EnableNetworkConfiguration = false;
          };
          Settings = {
            AutoConnect = "yes";
          };
        };
      };
    };
  };
  desktopPreset = {
    xyz.adtya.recipes.core.users.primary.extra-groups = [ "networkmanager" ];
    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };
    };
  };
in
{
  options = {
    xyz.adtya.recipes.networking = {
      preset = {
        desktop = lib.mkOption {
          type = lib.types.bool;
          default = desktop-cfg;
          defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
          description = "Enable the desktop preset for networking";
        };
      };
      wireless = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable WiFi";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.preset.desktop desktopPreset)
    (lib.mkIf (cfg.preset.desktop && cfg.wireless) wifiConfig)
  ];
}
