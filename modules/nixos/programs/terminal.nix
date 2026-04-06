{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.programs.terminal;
  preset-cfg = config.xyz.adtya.recipes.presets;
in
{
  options = {
    xyz.adtya.recipes.programs.terminal = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.desktop;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
        description = "Enable Terminal";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.ghostty;
        description = "Terminal package";
      };
    };
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = [ cfg.package ]; };
}
