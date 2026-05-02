{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.desktop.addons.dunst;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;
in
{

  options = {
    xyz.adtya.recipes.desktop.addons.dunst = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Dunst Notification Daemon";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/dunst         0755 ${user-cfg.name} ${user-cfg.group} - -"
      "L+ ${user-cfg.home}/.config/dunst/dunstrc -    -                -                 - ${./dunstrc}"
    ];

    systemd.user.services.dunst = {
      wantedBy = [ "graphical-session.target" ];
      unitConfig = {
        Description = "Dunst Notification Daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
      };
      serviceConfig = {
        ExecStart = lib.getExe pkgs.dunst;
        ExecReload = "${lib.getExe' pkgs.dunst "dunstctl"} reload";
        Restart = "on-failure";
      };
    };
  };
}

