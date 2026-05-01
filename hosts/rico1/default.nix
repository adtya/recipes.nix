_: {
  imports = [
    ./hardware
    ./services
  ];

  xyz.adtya.recipes = {
    hostinfo = {
      local-ip = "192.168.1.11";
      tailscale-ip = "100.69.69.11";
    };
    presets.server = true;
  };

  system.stateVersion = "23.11";
}
