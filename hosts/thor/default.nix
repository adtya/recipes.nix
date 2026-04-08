{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware
    ./remote
    ./services
  ];

  boot = {
    # required for nixos-rebuild if target-host is of different arch. (even if --build-host is used)
    binfmt = {
      emulatedSystems = [ "aarch64-linux" ];
      preferStaticEmulators = true; # cross-arch inside podman
    };
  };

  environment = {
    sessionVariables = {
      AMD_VULKAN_ICD = "RADV";
      MESA_SHADER_CACHE_MAX_SIZE = "12G";
    };

    systemPackages = with pkgs; [
      nvtopPackages.amd
      piper
    ];
  };

  # https://bugzilla.kernel.org/show_bug.cgi?id=218733
  networking.wireless.iwd.settings.General.ControlPortOverNL80211 = false;

  programs.gamemode = {
    settings = {
      cpu = {
        amd_x3d_mode_desired = "cache";
        amd_x3d_mode_default = "frequency";
      };
    };
  };

  xyz.adtya.recipes = {
    hostinfo = {
      host-name = "Thor";
      local-ip = "192.168.1.20";
      tailscale-ip = "100.69.69.1";
    };

    core = {
      nix.use-nh = true;
    };

    desktop = {
      dm.flavour = "gdm";
      gnome.enable = true;
    };

    misc = {
      bluetooth.enable = true;
      devtools.enable = true;
      gaming.enable = true;
    };

    networking.wireless = true;

    presets.desktop = true;

    virtualisation = {
      containers.enable = true;
      vms.enable = false;
    };
  };

  virtualisation.containers = {
    storage.settings = {
      storage.driver = "btrfs";
    };
  };

  system.stateVersion = "25.11";
}
