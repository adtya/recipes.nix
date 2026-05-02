{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.desktop.addons.hyprlock;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;
  hyprlock-conf = pkgs.replaceVars ./hyprlock.conf { ghost = ./ghost.png; };
in
{
  options = {
    xyz.adtya.recipes.desktop.addons.hyprlock = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Hyprlock";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    security.pam.services.hyprlock = { };
    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/hypr               0755 ${user-cfg.name} ${user-cfg.group} - -"
      "L+ ${user-cfg.home}/.config/hypr/hyprlock.conf -    -                -                 - ${hyprlock-conf}"
    ];
  };
}
