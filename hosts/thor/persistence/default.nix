{ config, ... }:
let
  hostname = config.networking.hostName;
in
{
  imports = [
    ./system.nix
    ./users.nix
  ];

  boot.initrd.systemd.services.rollback = {
    description = "Rollback root subvolume to blank state";
    wantedBy = [ "initrd.target" ];
    after = [ "dev-mapper-${hostname}\\x2dROOT.device" ];
    requires = [ "dev-mapper-${hostname}\\x2dROOT.device" ];
    before = [ "sysroot.mount" ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt
      mount -t btrfs -o subvol=/ /dev/mapper/${hostname}-ROOT /mnt

      btrfs subvolume list -o /mnt/@root | cut -f9 -d' ' | while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done &&
      echo "deleting /root subvolume..." &&
      btrfs subvolume delete "/mnt/@root"

      echo "creating blank /root subvolume..."
      btrfs subvolume create "/mnt/@root"

      umount /mnt
    '';
  };
}
