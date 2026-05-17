{ lib, pkgs, ... }:
{
  imports = [ ./filesystem.nix ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = [ "video=DP-1:3440x1440@175" ];

    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "thunderbolt"
        "usbhid"
        "xhci_pci"
      ];
      kernelModules = [ "dm-snapshot" ];
    };

    kernelModules = [
      "kvm-amd"
      "ntsync"
    ];
  };

  hardware = {
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive.enable = true;
    };
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    graphics.enable32Bit = true;
    steam-hardware.enable = true;
    xone.enable = true;
    xpad-noone.enable = lib.mkForce false;
  };
}
