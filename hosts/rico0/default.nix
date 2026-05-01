_: {
  imports = [
    ./hardware
    ./services
  ];

  xyz.adtya.recipes = {
    hostinfo = {
      local-ip = "192.168.1.10";
      tailscale-ip = "100.69.69.10";
    };
    presets.server = true;
  };

  system.stateVersion = "23.11";
}
