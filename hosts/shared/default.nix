{ inputs, ... }:
{
  imports = [

    ./users.nix
  ];

  xyz.adtya.recipes = {
    core = {
      nix = {
        auto-gc = true;
        auto-optimise = true;
      };
      sops = {
        enable = true;
        secrets-file = "${inputs.self}/secrets.yaml";
      };
    };

    services = {
      caddy = {
        email = "admin@ironyofprivacy.org";
        env-file = "caddy/env_file";
      };
      ssh.enable = true;
      tailscale = {
        enable = true;
        tailnet-name = "taila9bb20.ts.net";
        auth-file = "tailscale_auth";
      };
    };
  };

  boot = {
    initrd = {
      supportedFilesystems = [
        "vfat"
        "btrfs"
      ];
    };
    supportedFilesystems = [
      "vfat"
      "exfat"
      "ext4"
      "btrfs"
    ];
  };

  i18n = {
    defaultCharset = "UTF-8";
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "en_IN/UTF-8" ];
  };

  time.timeZone = "Asia/Kolkata";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
}
