_: {
  imports = [
    ./udev.nix
  ];

  services = {
    ratbagd.enable = true;
    lact.enable = true;
  };
}
