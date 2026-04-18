{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.programs.ghostty;
  hyprland-cfg = config.xyz.adtya.recipes.desktop.hyprland;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

  waybar-conf = pkgs.replaceVars ./config.jsonc {
    blueman = lib.getExe' pkgs.blueman "blueman-manager";
    pwvucontrol = lib.getExe pkgs.pwvucontrol;
  };
  waybar-style = ./style.css;
in
{
  options = {
    xyz.adtya.recipes.programs.waybar = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = hyprland-cfg.enable;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.desktop.hyprland.enable](#xyzadtyarecipesdesktophyprlandenable)";
        description = "Enable Waybar";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.waybar;
        description = "Waybar package";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    programs.waybar.enable = true;

    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/waybar              0755 ${user-cfg.name} ${user-cfg.group} - -"
      "L+ ${user-cfg.home}/.config/waybar/config.jsonc -    -                -                 - ${waybar-conf}"
      "L+ ${user-cfg.home}/.config/waybar/style.css    -    -                -                 - ${waybar-style}"
    ];
  };
}
