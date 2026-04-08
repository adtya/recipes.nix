{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./filesystem.nix ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "xhci_pci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sdhci_pci"
      ];
    };

    kernelModules = [
      "kvm-amd"
      "ntsync"
    ];
  };

  environment.sessionVariables.VDPAU_DRIVER = "radeonsi";

  hardware = {
    amdgpu.initrd.enable = true;
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    graphics.enable32Bit = true;
    xone.enable = true;
  };
}
