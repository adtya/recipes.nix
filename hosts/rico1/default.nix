_: {
  imports = [
    ./services
    ./filesystem.nix
  ];

  xyz.adtya.recipes = {
    hardware.pi4 = true;
    hostinfo = {
      host-name = "Rico1";
      local-ip = "192.168.1.11";
      tailscale-ip = "100.69.69.11";
    };
    presets.server = true;
  };

  system.stateVersion = "23.11";
}
