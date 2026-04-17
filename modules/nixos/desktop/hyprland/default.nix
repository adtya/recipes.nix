{ lib, pkgs, config, ... }:
let
  cfg = config.xyz.adtya.recipes.desktop.hyprland;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

  hyprland-pkg = pkgs.hyprland;
  xdph-pkg = pkgs.xdg-desktop-portal-hyprland;
  hyprland-conf = pkgs.replaceVars ./hyprland.conf {
    blueberry = lib.getExe' pkgs.blueberry "blueberry";
	  firefox = lib.getExe config.programs.firefox.finalPackage;
	  grimblast = lib.getExe pkgs.grimblast;
	  hyprctl = lib.getExe' hyprland-pkg "hyprctl";
	  ghostty = lib.getExe config.xyz.adtya.programs.terminal.package;
	  librewolf = lib.getExe pkgs.librewolf;
	  loginctl = lib.getExe' pkgs.systemd "loginctl";
	  playerctl = lib.getExe pkgs.playerctl;
	  rofi = lib.getExe config.programs.rofi.package;
	  wpctl = lib.getExe' pkgs.wireplumber "wpctl";
	  yazi = lib.getExe pkgs.yazi;
	  systemctl = lib.getExe' pkgs.systemd "systemctl";
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
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/hypr               0755 ${user-cfg.name} ${user-cfg.group} - -"
      "C+ ${user-cfg.home}/.config/hypr/hyprland.conf -    -                -                 - ${hyprland-conf}"
    ];

    services.displayManager.sessionPackages = [hyprland-pkg];

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
