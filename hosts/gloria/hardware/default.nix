{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./filesystem.nix ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };

    kernelModules = [
      "kvm-intel"
      "i915"
      "dm-snapshot"
    ];
  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        libvdpau-va-gl
      ];
    };
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
}
