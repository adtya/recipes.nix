{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.hardware.pi4;
in
{
  options = {
    xyz.adtya.recipes.hardware.pi4 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Raspberry Pi 4 specific stuff";
    };
  };

  config = lib.mkIf cfg {
    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      initrd.availableKernelModules = [
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "uas"
      ];
    };

    hardware.enableRedistributableFirmware = true;
  };
}
