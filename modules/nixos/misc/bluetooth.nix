{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.misc.bluetooth;
in
{
  options = {
    xyz.adtya.recipes.misc.bluetooth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Bluetooth";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = true;
        settings = {
          General = {
            Experimental = true;
            KernelExperimental = true;
            FastConnectable = true;
            ControllerMode = "dual";
          };
        };
        package = pkgs.bluez.override { enableExperimental = true; };
      };
    };
  };
}
