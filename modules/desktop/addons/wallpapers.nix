{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.desktop.addons.wallpapers;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

  awww = lib.getExe pkgs.awww;
  find = lib.getExe pkgs.findutils;
  shuf = lib.getExe' pkgs.coreutils "shuf";

  wallpaperDir = "${user-cfg.home}/Pictures/Wallpapers";
  wallpaperScript = pkgs.writeShellScriptBin "update-wallpaper" ''
    ${awww} img -t fade --transition-duration 1 $(${find} ${wallpaperDir}/ -type f -regextype egrep -regex '.*\.(jpe?g|png)' | ${shuf} -n1)
  '';
in
{
  options = {
    xyz.adtya.recipes.desktop.addons.wallpapers = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Managing wallpapers with AWWW";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user = {
      services = {
        wallpaper-daemon = {
          wantedBy = [ "graphical-session.target" ];
          unitConfig = {
            Description = "SWWW Wallpaper daemon";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
            ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
          };
          serviceConfig = {
            ExecStart = lib.getExe' pkgs.awww "awww-daemon";
            Restart = "on-failure";
          };
        };
        update-wallpaper = {
          wantedBy = [ "graphical-session.target" ];
          unitConfig = {
            Description = "AWWW Wallpaper updater";
            PartOf = [ "graphical-session.target" ];
            After = [
              "graphical-session.target"
              "awww.service"
            ];
            Requires = [ "wallpaper-daemon.service" ];
            ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
          };
          serviceConfig = {
            Type = "oneshot";
            ExecStart = lib.getExe wallpaperScript;
            Restart = "on-failure";
          };
        };
      };
      timers.update-wallpaper = {
        wantedBy = [ "graphical-session.target" ];
        unitConfig = {
          Description = "AWWW Wallpaper update timer";
        };
        timerConfig = {
          OnCalendar = "*:0/10";
        };
      };
    };
  };
}
