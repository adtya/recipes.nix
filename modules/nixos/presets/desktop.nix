{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.presets.desktop;
in
{
  options = {
    xyz.adtya.recipes.presets.desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the desktop preset";
    };
  };

  config = lib.mkIf cfg {

    programs = {
      command-not-found.enable = false;
      fuse.userAllowOther = true;
    };

    security = {
      pam = {
        services = {
          passwd.enableGnomeKeyring = true;
          login.enableGnomeKeyring = true;
        };
      };
      rtkit.enable = true;
    };

    services = {
      flatpak.enable = true;
      fstrim.enable = true;
      fwupd.enable = true;
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
      pcscd.enable = true;
      power-profiles-daemon.enable = true;
      udisks2.enable = true;
    };
  };
}
