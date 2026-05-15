{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.services.easyeffects;
  preset-cfg = config.xyz.adtya.recipes.presets;

  easyeffects-pkg = pkgs.easyeffects;
in
{
  options = {
    xyz.adtya.recipes.services.easyeffects = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.desktop;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
        description = "Enable EasyEffects";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ easyeffects-pkg ];
    systemd.user.services.easyeffects = {
      wantedBy = [ "graphical-session.target" ];
      unitConfig = {
        Description = "EasyEffects Daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      serviceConfig = {
        ExecStart = "${lib.getExe easyeffects-pkg} --hide-window --service-mode";
        ExecStop = "${lib.getExe easyeffects-pkg} --quit";
        KillMode = "mixed";
        Restart = "on-failure";
        RestartSec = 5;
        TimeoutStopSec = 10;
        Slice = "background.slice";
      };
    };
  };
}
