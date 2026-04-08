_: {
  imports = [
    ./ollama.nix
    ./udev.nix
  ];

  services = {
    ratbagd.enable = true;
    lact.enable = true;
  };
}
