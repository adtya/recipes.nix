{ lib, ... }:
{
  imports = [ ./plymouth.nix ];

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
}
