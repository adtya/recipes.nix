{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.presets;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;
  xdg-dirs = {
    DESKTOP = "Desktop";
    DOCUMENTS = "Documents";
    DOWNLOADS = "Downloads";
    MUSIC = "Music";
    PICTURES = "Pictures";
    PROJECTS = "Projects";
    SCREENSHOTS = "Pictures/Screenshots";
    VIDEOS = "Videos";
  };

  packages = with pkgs; [
    btop
    evince
    file
    localsend
    (imv.overrideAttrs (
      _final: _prev: {
        postInstall = ''
          rm $out/share/applications/imv.desktop
        '';
      }
    ))
    unzip
    wl-clipboard
    xdg-user-dirs
    xdg-utils
  ];
  extra-packages = with pkgs; [
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

  config = lib.mkIf cfg.desktop {
    boot = {
      bootspec.enable = true;
      initrd.verbose = false;
      kernelParams = [ "quiet" ];
    };

    console.useXkbConfig = true;

    environment = {
      pathsToLink = [ "/share" ];
      sessionVariables = {
        NIXOS_OZONE_WL = 1;
      }
      // (lib.attrsets.mapAttrs' (
        name: value: lib.nameValuePair "XDG_${name}_DIR" "$HOME/${value}"
      ) xdg-dirs);
      systemPackages = if cfg.desktop-minimal then packages else (packages ++ extra-packages);
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

    systemd.tmpfiles.settings.xdg-dirs = lib.attrsets.mapAttrs' (
      _name: value:
      lib.nameValuePair "${user-cfg.home}/${value}" {
        d = {
          user = user-cfg.name;
          inherit (user-cfg) group;
          mode = "755";
        };
      }
    ) xdg-dirs;
  };
}
