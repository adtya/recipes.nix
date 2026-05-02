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
    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/rofi                     0755 ${user-cfg.name} ${user-cfg.group} - -"
      "d  ${user-cfg.home}/.config/rofi/themes              0755 ${user-cfg.name} ${user-cfg.group} - -"
      "L+ ${user-cfg.home}/.config/rofi/config.rasi         -    -                -                 - ${./config.rasi}"
      "L+ ${user-cfg.home}/.config/rofi/themes/dracula.rasi -    -                -                 - ${./dracula.rasi}"
    ];
  };
}
