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
    boot = {
      bootspec.enable = true;
      consoleLogLevel = 3;
      initrd = {
        systemd.enable = true;
        verbose = false;
      };
      kernelParams = [ "quiet" ];
      kernel.sysctl = {
        "vm.dirty_ratio" = 3;
      };
      loader = {
        timeout = 0;
        efi.canTouchEfiVariables = true;
      };
    };

    console.useXkbConfig = true;

    environment = {
      pathsToLink = [ "/share" ];
      sessionVariables = {
        NIXOS_OZONE_WL = 1;
      };
    };

    gtk.iconCache.enable = true;

    hardware.graphics.enable = true;

    i18n = {
      extraLocales = [ "ml_IN/UTF-8" ];
    };

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
      xserver.xkb = {
        layout = "us";
        options = "rupeesign:4";
        variant = "altgr-intl";
      };

    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
