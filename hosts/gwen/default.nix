{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware
    ./jovian.nix
  ];

  boot = {
    loader.systemd-boot = {
      consoleMode = "5";
    };
  };

  networking.firewall.enable = false;

  environment = {
    sessionVariables = {
      AMD_VULKAN_ICD = "RADV";
      MESA_SHADER_CACHE_MAX_SIZE = "12G";
    };

    systemPackages = with pkgs; [ nvtopPackages.amd ];
  };

  xyz.adtya.recipes = {
    boot.plymouth.theme = "owl";

    hostinfo = {
      host-name = "Gwen";
      tailscale-ip = "100.69.69.5";
    };

    core = {
      nix.use-nh = true;
    };

    desktop = {
      gnome.enable = true;
    };

    misc = {
      gaming = {
        enable = true;
        lutris = false;
      };
    };

    networking.wireless = true;

    presets = {
      desktop = true;
      desktop-minimal = true;
    };
  };

  system.stateVersion = "26.05";
}
