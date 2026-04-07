{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.presets.desktop;
  packages = with pkgs;
    [
      btop
      celluloid
      file
      localsend
      (mpv.override {
        youtubeSupport = true;
        scripts = with pkgs.mpvScripts; [ mpris ];
      })
      unzip
      wl-clipboard
      xdg-utils
    ];
  extra-packages = with pkgs;
    [
      _1password-cli
      _1password-gui
      bitwarden-cli
      bitwarden-desktop
      discord
      spotify
      transmission_4-gtk
      android-file-transfer
    ];
in
{
  options = {
    xyz.adtya.recipes.presets = {
      desktop = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the desktop preset";
      };
      desktop-minimal = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use a minimal version of the desktop preset";
      };
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
        timeout = 5;
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
      };
    };

    console.useXkbConfig = true;

    environment = {
      pathsToLink = [ "/share" ];
      sessionVariables = {
        NIXOS_OZONE_WL = 1;
      };
      systemPackages = packages ++ (if cfg.desktop-minimal then [ ] else extra-packages);
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
