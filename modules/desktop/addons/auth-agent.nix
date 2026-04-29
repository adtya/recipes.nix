{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.desktop.addons.auth-agent;

in
{

  options = {
    xyz.adtya.recipes.desktop.addons.auth-agent = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Polikit Authentication Agent";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.auth-agent = {
      wantedBy = [ "graphical-session.target" ];
      unitConfig = {
        Description = "Polkit Authentication Agent";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
      };
      serviceConfig = {
        ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
        Restart = "on-failure";
      };
    };
  };
}
