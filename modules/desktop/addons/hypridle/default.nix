{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.desktop.addons.hypridle;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

  hyprland-pkg = config.programs.hyprland.package;

  brightnessctl = lib.getExe pkgs.brightnessctl;

  display-backlight-conf = lib.optionalString (cfg.backlight.display != null) ''
    listener {
          timeout = 150
          on-timeout = ${brightnessctl} --quiet --device=${cfg.backlight.display} --save set 30
          on-resume = ${brightnessctl} --quiet --device=${cfg.backlight.display} --restore
    }
  '';
  keyboard-backlight-conf = lib.optionalString (cfg.backlight.keyboard != null) ''
    listener {
          timeout = 10
          on-timeout = ${brightnessctl} --quiet --device=${cfg.backlight.keyboard} --save set 0
          on-resume = ${brightnessctl} --quiet --device=${cfg.backlight.keyboard} --restore
    }
  '';

  hypridle-conf = pkgs.replaceVars ./hypridle.conf {
    hyprctl = lib.getExe' hyprland-pkg "hyprctl";
    hyprlock = lib.getExe pkgs.hyprlock;
    loginctl = lib.getExe' pkgs.systemd "loginctl";
    pidof = lib.getExe' pkgs.procps "pidof";
    pkill = lib.getExe' pkgs.procps "pkill";
    systemctl = lib.getExe' pkgs.systemd "systemctl";

    inherit (cfg.timeouts) lock screen-off suspend;

    extra-config = lib.strings.concatLines [
      display-backlight-conf
      keyboard-backlight-conf
    ];
  };
in
{
  options = {
    xyz.adtya.recipes.desktop.addons.hypridle = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Hypridle";
      };
      backlight.display = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Name of LED device for display backlight, if present (eg. intel_backlight)";
      };
      backlight.keyboard = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Name of LED device for keyboard backlight, if present (eg. dell::kbd_backlight)";
      };
      timeouts = {
        lock = lib.mkOption {
          type = lib.types.int;
          default = 300;
          description = "Number of seconds of idling before the screen is locked";
        };
        screen-off = lib.mkOption {
          type = lib.types.int;
          default = 420;
          description = "Number of seconds of idling before the screen is turned off";
        };
        suspend = lib.mkOption {
          type = lib.types.int;
          default = 600;
          description = "Number of seconds of idling before going to sleep";
        };

      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.hypridle.enable = true;

    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/hypr               0755 ${user-cfg.name} ${user-cfg.group} - -"
      "L+ ${user-cfg.home}/.config/hypr/hypridle.conf -    -                -                 - ${hypridle-conf}"
    ];
  };
}
