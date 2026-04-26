{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.desktop.dm;
  gdmConfig = {
    services.displayManager.gdm = {
      enable = true;
      autoSuspend = false;
      wayland = true;
    };
  };
in

{
  imports = [
    ./addons
    ./hyprland

    ./gnome.nix
  ];

  options = {
    xyz.adtya.recipes.desktop.dm = {
      flavour = lib.mkOption {
        type = lib.types.enum [
          "cosmic"
          "gdm"
          "none"
        ];
        default = "none";
        description = "Display manager of choice";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.flavour != "none") { services.displayManager.enable = true; })
    (lib.mkIf (cfg.flavour == "cosmic") { services.displayManager.cosmic-greeter.enable = true; })
    (lib.mkIf (cfg.flavour == "gdm") gdmConfig)
  ];
}
