{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.desktop.hyprland;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

  hyprland-pkg = pkgs.hyprland;
  xdph-pkg = pkgs.xdg-desktop-portal-hyprland;

  hyprland-extra-conf = pkgs.writeTextFile {
    name = "hyprland-extra.conf";
    text = cfg.extraConfig;
  };

  hyprland-conf = pkgs.replaceVars ./hyprland.conf {
    blueman = lib.getExe' pkgs.blueman "blueman-manager";
    firefox = lib.getExe config.programs.firefox.package;
    grimblast = lib.getExe pkgs.grimblast;
    hyprctl = lib.getExe' hyprland-pkg "hyprctl";
    ghostty = lib.getExe config.xyz.adtya.recipes.programs.terminal.package;
    librewolf = lib.getExe pkgs.librewolf;
    loginctl = lib.getExe' pkgs.systemd "loginctl";
    playerctl = lib.getExe pkgs.playerctl;
    rofi = lib.getExe pkgs.rofi;
    wpctl = lib.getExe' pkgs.wireplumber "wpctl";
    yazi = lib.getExe pkgs.yazi;
    systemctl = lib.getExe' pkgs.systemd "systemctl";
    power-menu = "/dev/null";

    extra-config = if cfg.extraConfig != "" then "source ${hyprland-extra-conf}" else "";

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
      extraConfig = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Additional hyprland configuration that will be added to the default config";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/hypr               0755 ${user-cfg.name} ${user-cfg.group} - -"
      "L+ ${user-cfg.home}/.config/hypr/hyprland.conf -    -                -                 - ${hyprland-conf}"
    ];

    programs.hyprland.enable = true;

    services.displayManager.sessionPackages = [ hyprland-pkg ];

    environment.systemPackages = [
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
