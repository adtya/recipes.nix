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
    systemd.tmpfiles.settings.hypr = {
      "${user-cfg.home}/.config/hypr".d = {
        user = user-cfg.name;
        inherit (user-cfg) group;
        mode = "755";
      };
    };
    systemd.tmpfiles.settings.hyprlock = {
      "${user-cfg.home}/.config/hypr/hyprlock.conf"."L+" = {
        argument = "${hyprlock-conf}";
      };
    };
  };
}
