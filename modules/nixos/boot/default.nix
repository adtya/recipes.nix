{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.boot.default;
in
{
  imports = [ ./plymouth.nix ];

  options = {
    xyz.adtya.recipes.boot = {
      default = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable the default boot config";
      };
    };
  };

  config = lib.mkIf cfg {
    boot = {
      consoleLogLevel = 3;
      initrd = {
        systemd.enable = true;
      };
      kernel.sysctl = {
        "vm.dirty_ratio" = 3;
      };
      loader = {
        timeout = lib.mkDefault 5;
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          configurationLimit = 15;
        };
      };
    };
  };
}
