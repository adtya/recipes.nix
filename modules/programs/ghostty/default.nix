{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.programs.ghostty;
  preset-cfg = config.xyz.adtya.recipes.presets;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

  ghostty-conf = ./config.ghostty;
in
{
  options = {
    xyz.adtya.recipes.programs.ghostty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.desktop;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
        description = "Enable Ghostty";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.ghostty;
        description = "Ghostty package package";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.tmpfiles.rules = [
      "d  ${user-cfg.home}/.config/ghostty                0755 ${user-cfg.name} ${user-cfg.group} - -"
      "L+ ${user-cfg.home}/.config/ghostty/config.ghostty -    -                -                 - ${ghostty-conf}"
    ];
  };
}
