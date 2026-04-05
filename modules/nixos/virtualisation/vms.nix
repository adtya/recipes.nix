{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.virtualisation.vms;
in
{
  options = {
    xyz.adtya.recipes.virtualisation.vms = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable VMs with libvirt";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
        };
      };
    };

    xyz.adtya.recipes = {
      core = {
        users.primary.extra-groups = [ "libvirtd" ];
      };
    };
  };
}
