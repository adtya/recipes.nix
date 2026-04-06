{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.desktop.gnome;
  terminal-cfg = config.xyz.adtya.recipes.programs.terminal;
  enabled-extensions = with pkgs.gnomeExtensions; [
    appindicator
    caffeine
    just-perfection
    removable-drive-menu
    user-themes
  ];
in

{
  options = {
    xyz.adtya.recipes.desktop.gnome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable GNOME";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.gnome.enable = true;
      gnome = {
        gnome-initial-setup.enable = false;
        gnome-user-share.enable = false;
        rygel.enable = false;
      };
    };

    environment.systemPackages = (with pkgs; [ bibata-cursors ]) ++ enabled-extensions;

    environment.gnome.excludePackages = with pkgs; [
      decibels
      epiphany
      gnome-calendar
      gnome-clocks
      gnome-connections
      gnome-console
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-software
      gnome-text-editor
      gnome-tour
      gnome-weather
      showtime
      simple-scan
      snapshot
      yelp
    ];

    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          lockAll = true;
          settings = {
            "org/gnome/settings-daemon/plugins/media-keys" = {
              www = [ "<Super>i" ];
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
              name = "Terminal";
              command = lib.getExe terminal-cfg.package;
              binding = "<Super>Return";
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
              name = "Librewolf";
              command = lib.getExe pkgs.librewolf;
              binding = "<Shift><Super>i";
            };

            "org/gnome/desktop/interface" = {
              accent-color = "purple";
              color-scheme = "prefer-dark";
              cursor-theme = "Bibata-Modern-Amber";
              monospace-font-name = "Fira Code 11";
            };
            "org/gnome/desktop/sound" = {
              event-sounds = false;
            };
            "org/gnome/desktop/wm/preferences" = {
              button-layout = "appmenu:close";
            };
            "org/gnome/mutter" = {
              experimental-features = [ "variable-refresh-rate" ];
            };
            "org/gnome/shell" = {
              enabled-extensions = builtins.map (e: e.extensionUuid) enabled-extensions;
            };

            "org/gnome/shell/extensions/appindicator" = {
              icon-size = lib.gvariant.mkInt32 16;
            };
            "org/gnome/shell/keybindings" = {
              toggle-application-view = [ "<Super>d" ];
            };
            "org/gnome/desktop/wm/keybindings" = {
              close = [ "<Shift><Super>q" ];
              toggle-fullscreen = [ "<Super>f" ];
            };
            "org/gnome/mutter/wayland/keybindings" = {
              restore-shortcuts = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
            };
          };
        }
      ];
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita";
    };
  };
}
