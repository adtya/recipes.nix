{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2

    ./filesystem.nix
  ];

  hardware.apple-t2 = {
    enableIGPU = true;
    kernelChannel = "latest";
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
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
