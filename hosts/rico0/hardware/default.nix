{ lib, pkgs, ... }:
{
  imports = [ ./filesystem.nix ];
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
}

