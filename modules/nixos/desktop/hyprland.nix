{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.desktop.hyprland;
in

{
  options = {
    xyz.adtya.recipes.desktop.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Hyprland";
      };
    };
  };

  config = lib.mkIf cfg.enable { };

}
