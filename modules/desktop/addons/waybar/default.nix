{
  lib,
  config,
  pkgs,
  ...
}:
let
  configFormat = pkgs.formats.json { };
  cfg = config.xyz.adtya.recipes.desktop.addons.waybar;
  hyprland-cfg = config.xyz.adtya.recipes.desktop.hyprland;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

  waybar-config = import ./config.nix {
    inherit (cfg) laptop-mode;
    blueman = lib.getExe' pkgs.blueman "blueman-manager";
    pwvucontrol = lib.getExe pkgs.pwvucontrol;

  };
  waybar-style = ./style.css;
  waybar-config-file = configFormat.generate "config.jsonc" waybar-config;
in
{
  options = {
    xyz.adtya.recipes.desktop.addons.waybar = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Waybar";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.waybar;
        description = "Waybar package";
      };
      laptop-mode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable laptop-relevant modules";
      };

    };
  };

  config = lib.mkIf cfg.enable {

    programs.waybar.enable = true;

    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/waybar              0755 ${user-cfg.name} ${user-cfg.group} - -"
      "L+ ${user-cfg.home}/.config/waybar/config.jsonc -    -                -                 - ${waybar-config-file}"
      "L+ ${user-cfg.home}/.config/waybar/style.css    -    -                -                 - ${waybar-style}"
    ];
  };
}
