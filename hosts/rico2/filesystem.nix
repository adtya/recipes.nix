{ config, inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/mnt/system" ];
  };

  disko.devices.disk = {
    "${config.networking.hostName}" = {
      device = "/dev/disk/by-id/usb-Samsung_Type-C_0375421070003215-0:0";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          FIRMWARE = {
            type = "EF00";
            size = "512M";
            priority = 1;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/firmware";
              mountOptions = [ "umask=0077" ];
            };
          };
          BOOT = {
            size = "1G";
            priority = 2;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/boot";
              mountOptions = [ "relatime" ];
            };
          };
          SYSTEM = {
            size = "100%";
            priority = 3;
            content = {
              type = "btrfs";
              mountpoint = "/mnt/system";
              mountOptions = [
                "compress=zstd"
                "relatime"
              ];
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "relatime"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "relatime"
                  ];
                };
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd"
                    "relatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
  fileSystems."/persist".neededForBoot = true;
}
