{ inputs, ... }:
{
  imports = [
    ./boot
    ./core
    ./desktop
    ./hardware
    ./misc
    ./networking
    ./presets
    ./programs
    ./services
    ./virtualisation

    ./hostinfo.nix
  ];
}
