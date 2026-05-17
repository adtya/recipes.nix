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
        description = "Ghostty package";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.tmpfiles.settings.ghostty = {
      "${user-cfg.home}/.config/ghostty".d = {
        user = user-cfg.name;
        inherit (user-cfg) group;
        mode = "755";
      };
      "${user-cfg.home}/.config/ghostty/config.ghostty"."L+" = {
        argument = "${ghostty-conf}";
      };
    };
  };
}
