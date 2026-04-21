_: {
  imports = [
    ./services
    ./filesystem.nix
  ];

  xyz.adtya.recipes = {
    hardware.pi4 = true;
    hostinfo = {
      local-ip = "192.168.1.10";
      tailscale-ip = "100.69.69.10";
    };
    presets.server = true;
  };

  system.stateVersion = "23.11";
}
