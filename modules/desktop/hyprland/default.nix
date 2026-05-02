{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.desktop.hyprland;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

  hyprland-pkg = config.programs.hyprland.package;
  xdph-pkg = config.programs.hyprland.portalPackage;

  hdr-conf = lib.optionalString cfg.hdr ''
    render {
      cm_auto_hdr = 2
    }
  '';

  vrr-conf = lib.optionalString cfg.vrr ''
    misc {
      vrr = 2
    }
  '';

  backlight-conf =
    let
      brightnessctl = lib.getExe pkgs.brightnessctl;
    in
    lib.optionalString (cfg.backlight-device != null) ''
      binde = ,XF86MonBrightnessUp,   exec, ${brightnessctl} --quiet --device=intel_backlight set +5%
      binde = ,XF86MonBrightnessDown, exec, ${brightnessctl} --quiet --device=intel_backlight set 5%-
    '';

  laptop-conf = lib.optionalString cfg.laptop-mode ''
    input {
      touchpad {
        clickfinger_behavior = true
        disable_while_typing = true
        natural_scroll = true
        tap-to-click = true
      }
    }

    gesture = 3, horizontal, workspace
  '';

  hyprland-conf = pkgs.replaceVars ./hyprland.conf {
    blueman = lib.getExe' pkgs.blueman "blueman-manager";
    firefox = lib.getExe config.programs.firefox.package;
    grimblast = lib.getExe pkgs.grimblast;
    hyprctl = lib.getExe' hyprland-pkg "hyprctl";
    ghostty = lib.getExe config.xyz.adtya.recipes.programs.ghostty.package;
    librewolf = lib.getExe pkgs.librewolf;
    loginctl = lib.getExe' pkgs.systemd "loginctl";
    playerctl = lib.getExe pkgs.playerctl;
    rofi = lib.getExe pkgs.rofi;
    runapp = lib.getExe pkgs.runapp;
    wpctl = lib.getExe' pkgs.wireplumber "wpctl";
    yazi = lib.getExe pkgs.yazi;
    systemctl = lib.getExe' pkgs.systemd "systemctl";
    power-menu = "/dev/null";

    extra-config = lib.strings.concatLines [
      hdr-conf
      vrr-conf
      backlight-conf
      laptop-conf
      cfg.extraConfig
    ];

    # wireplumber uses @..@ to specify default sink. setting null so it's ignored by replaceVars
    DEFAULT_AUDIO_SINK = null;
  };
in

{
  options = {
    xyz.adtya.recipes.desktop.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Hyprland";
      };
      laptop-mode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable laptop-relevant features in hyprland and friends";
      };
      hdr = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable HDR";
      };
      vrr = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable VRR";
      };
      backlight-device = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "the name of the display backlight device, if present (eg. intel_backlight)";
      };
      extraConfig = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Additional hyprland configuration that will be added to the default config";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xyz.adtya.recipes.desktop.addons = {
      auth-agent.enable = true;
      dunst.enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      wallpapers.enable = true;
      waybar = {
        enable = true;
        inherit (cfg) laptop-mode;
      };
    };

    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/hypr               0755 ${user-cfg.name} ${user-cfg.group} - -"
      "L+ ${user-cfg.home}/.config/hypr/hyprland.conf -    -                -                 - ${hyprland-conf}"
    ];

    programs = {
      dconf = {
        profiles.user.databases = [
          {
            lockAll = true;
            settings = {
              "org/gnome/desktop/sound" = {
                event-sounds = false;
              };
              "org/gnome/desktop/wm/preferences" = {
                button-layout = "appmenu:close";
              };
              "org/gnome/desktop/interface" = {
                accent-color = "purple";
                color-scheme = "prefer-dark";
                cursor-theme = "Bibata-Modern-Amber";
                gtk-theme = "Dracula";
                icon-theme = "Dracula";
                monospace-font-name = "Fira Code 11";
              };
            };
          }
        ];
      };

      hyprland = {
        enable = true;
        withUWSM = true;
      };
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita";
    };

    environment.systemPackages = [
      pkgs.bibata-cursors
      pkgs.dracula-theme
      pkgs.dracula-icon-theme
      pkgs.adwaita-icon-theme
      pkgs.gnome-themes-extra
    ];

    xdg.portal = {
      extraPortals = [
        xdph-pkg
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [
            "gtk"
            "*"
          ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
        Hyprland = {
          default = [
            "gtk"
            "Hyprland"
            "*"
          ];
        };
      };
    };
  };
}
