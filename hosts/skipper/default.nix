{ inputs, ... }:
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    ./hardware
    ./services
    ./boot.nix
    ./network.nix
  ];

  xyz.adtya.recipes = {
    hostinfo = {
      host-name = "Skipper";
    };

    networking.wireless = true;
    presets.desktop = true;
  };
  system.stateVersion = "23.11";
}
