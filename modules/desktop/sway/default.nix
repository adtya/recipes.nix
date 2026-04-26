{lib, config, pkgs, ...}: let
  cfg = config.xyz.adtya.recipes.desktop.sway;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

  sway-conf = pkgs.replaceVars ./config {
    #blueman = lib.getExe' pkgs.blueman "blueman-manager";
    #firefox = lib.getExe config.programs.firefox.package;
    #grimblast = lib.getExe pkgs.grimblast;
    #hyprctl = lib.getExe' hyprland-pkg "hyprctl";
    ghostty = lib.getExe config.xyz.adtya.recipes.programs.ghostty.package;
    #librewolf = lib.getExe pkgs.librewolf;
    #loginctl = lib.getExe' pkgs.systemd "loginctl";
    #playerctl = lib.getExe pkgs.playerctl;
    rofi = lib.getExe pkgs.rofi;
    #wpctl = lib.getExe' pkgs.wireplumber "wpctl";
    #yazi = lib.getExe pkgs.yazi;
    #systemctl = lib.getExe' pkgs.systemd "systemctl";
    #power-menu = "/dev/null";

    #extra-config = if cfg.extraConfig != "" then "source = ${hyprland-extra-conf}" else "";

    # wireplumber uses @..@ to specify default sink. setting null so it's ignored by replaceVars
    #DEFAULT_AUDIO_SINK = null;
  };
in {
  options = {
    xyz.adtya.recipes.desktop.sway = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable SwayWM";
      };
    };
  };
  
  config = lib.mkIf cfg.enable {
    xyz.adtya.recipes.desktop.addons = {
      waybar.enable = true;
    };
    
    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/sway        0755 ${user-cfg.name} ${user-cfg.group} - -"
      "L+ ${user-cfg.home}/.config/sway/config -    -                -                 - ${sway-conf}"
    ];

    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
    };

    xdg.portal = {
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
