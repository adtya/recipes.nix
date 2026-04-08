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
    # https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243
    nixpkgs.overlays = [
      (_final: super: {
        makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];

    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi4;
      initrd.availableKernelModules = [ "xhci_pci" ];
    };

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    hardware.enableRedistributableFirmware = true;
  };
}
