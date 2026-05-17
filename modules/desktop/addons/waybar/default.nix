{
  lib,
  config,
  pkgs,
  ...
}:
let
  configFormat = pkgs.formats.json { };
  cfg = config.xyz.adtya.recipes.desktop.addons.waybar;
  user-cfg = config.xyz.adtya.recipes.core.users.primary;

  waybar-config = import ./config.nix {
    inherit (cfg) laptop-mode;
    blueman = lib.getExe' pkgs.blueman "blueman-manager";
    pwvucontrol = lib.getExe pkgs.pwvucontrol;

  };
  waybar-style = ./style.css;
  waybar-config-file = configFormat.generate "config.jsonc" waybar-config;
in
{
  options = {
    xyz.adtya.recipes.desktop.addons.waybar = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Waybar";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.waybar;
        description = "Waybar package";
      };
      laptop-mode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable laptop-relevant modules";
      };

    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar.enable = true;
    systemd.tmpfiles.settings.waybar = {
      "${user-cfg.home}/.config/waybar".d = {
        user = user-cfg.name;
        inherit (user-cfg) group;
        mode = "755";
      };
      "${user-cfg.home}/.config/waybar/config.jsonc"."L+" = {
        argument = "${waybar-config-file}";
      };
      "${user-cfg.home}/.config/waybar/style.css"."L+" = {
        argument = "${waybar-style}";
      };
    };
  };
}
