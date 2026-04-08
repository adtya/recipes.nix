{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./hardware ];

  nix.settings = {
    extra-substituters = [
      "https://cache.soopy.moe"
      "https://t2linux.cachix.org"
    ];
    extra-trusted-substituters = [
      "https://cache.soopy.moe"
      "https://t2linux.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
      "t2linux.cachix.org-1:P733c5Gt1qTcxsm+Bae0renWnT8OLs0u9+yfaK2Bejw="
    ];
  };

  networking.networkmanager.unmanaged = [ "mac:ac:de:48:00:11:22" ];

  xyz.adtya.recipes = {
    boot.plymouth.enable = false;
    hostinfo = {
      host-name = "Gloria";
      tailscale-ip = "100.69.69.3";
    };

    core = {
      nix.use-nh = true;
    };

    desktop = {
      dm.flavour = "gdm";
      gnome.enable = true;
    };

    misc.devtools.enable = true;

    networking.wireless = false;

    presets = {
      desktop = true;
    };
  };

  system.stateVersion = "26.05";
}
