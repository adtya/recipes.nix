{
  lib,
  config,
  pkgs,
  ...
}:
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

    environment.systemPackages = with pkgs; [ ghostty ];

    programs = {
      command-not-found.enable = false;
      dconf.enable = true;
      fuse.userAllowOther = true;
      xwayland.enable = true;
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
      udev.enable = true;
      udisks2.enable = true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
