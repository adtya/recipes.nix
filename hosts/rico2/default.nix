_: {
  imports = [
    ./hardware
    ./services
  ];

  xyz.adtya.recipes = {
    boot.default = false; # conflicts with boot setup from nixos-hardware
    hostinfo = {
      local-ip = "192.168.1.12";
      tailscale-ip = "100.69.69.12";
    };
    presets.server = true;
  };

  system.stateVersion = "23.11";
}
