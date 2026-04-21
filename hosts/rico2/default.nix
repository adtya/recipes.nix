_: {
  imports = [
    ./filesystem.nix

    ./services
  ];

  xyz.adtya.recipes = {
    hardware.pi4 = true;
    hostinfo = {
      local-ip = "192.168.1.12";
      tailscale-ip = "100.69.69.12";
    };
    presets.server = true;
  };

  system.stateVersion = "23.11";
}
