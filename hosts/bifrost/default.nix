{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")

    ./services
  ];

  xyz.adtya.recipes = {
    boot.default = false; # DigitalOcean mode. uses GRUB so the default boot config will bork it
    hostinfo = {
      host-name = "Bifrost";
      tailscale-ip = "100.69.69.4";
    };
    presets.server = true;
  };

  system.stateVersion = "25.11";
}
