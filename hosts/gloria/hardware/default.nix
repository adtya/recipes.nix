{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  amdgpu-pm = pkgs.writeTextFile {
    name = "amdgpu-pm-rules";
    text = ''
      SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="low"
    '';
    destination = "/etc/udev/rules.d/30-amdgpu-pm.rules";
  };
  mutter-preferred-primary-gpu = pkgs.writeTextFile {
    name = "mutter-preferred-primary-gpu-rules";
    text = ''
      SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_minor", ENV{DEVNAME}=="/dev/dri/card[0-9]", SUBSYSTEMS=="pci", ATTRS{vendor}=="0x8086", ATTRS{device}=="0x3e9b", TAG+="mutter-device-preferred-primary"
    '';
    destination = "/etc/udev/rules.d/61-mutter-preferred-primary-gpu.rules";
  };
  brcm-firmware = pkgs.stdenvNoCC.mkDerivation (final: {
    name = "brcm-firmware";
    src = pkgs.fetchzip {
      url = "https://static.labs.adtya.xyz/firmware.tar";
      hash = "sha256-0BBKMXC4WcEI/IH2/JDH7maKwePUlXqDxYoEpOQqdNc=";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p $out/lib/firmware/
      cp -ra ${final.src} $out/lib/firmware/brcm
    '';
  });
in

{
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2

    ./filesystem.nix
  ];

  hardware.apple-t2 = {
    enableIGPU = true;
    kernelChannel = "latest";
  };

  services.udev.packages = [
    amdgpu-pm
    mutter-preferred-primary-gpu
  ];

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

    kernelParams = [
      "amdgpu.dpm=0"
      "hid_apple.swap_opt_cmd=1"
    ];
  };

  hardware = {
    bluetooth.powerOnBoot = false;
    firmware = [ brcm-firmware ];
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
