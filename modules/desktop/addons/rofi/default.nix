{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.desktop.addons.rofi;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

in
{

  options = {
    xyz.adtya.recipes.desktop.addons.rofi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Rofi";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rofi ];
    systemd.tmpfiles.settings.rofi = {
      "${user-cfg.home}/.config/rofi".d = {
        user = user-cfg.name;
        inherit (user-cfg) group;
        mode = "755";
      };
      "${user-cfg.home}/.config/rofi/themes".d = {
        user = user-cfg.name;
        inherit (user-cfg) group;
        mode = "755";
      };
      "${user-cfg.home}/.config/rofi/config.rasi"."L+" = {
        argument = "${./config.rasi}";
      };
      "${user-cfg.home}/.config/rofi/themes/dracula.rasi"."L+" = {
        argument = "${./dracula.rasi}";
      };
    };
  };
}
