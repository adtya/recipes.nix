{ config, inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/mnt/system" ];
  };

  disko.devices.disk = {
    "${config.networking.hostName}" = {
      device = "/dev/disk/by-id/nvme-APPLE_SSD_AP0512N_C02208300ZQNFHTAF";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          CRYPT = {
            size = "100%";
            content = {
              type = "luks";
              name = "${config.networking.hostName}-ROOT";
              settings = {
                allowDiscards = true;
                bypassWorkqueues = true;
              };
              initrdUnlock = true;
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
  };
  fileSystems."/persist".neededForBoot = true;
}
