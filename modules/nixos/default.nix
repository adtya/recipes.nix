_: {
  imports = [
    inputs.sops-nix.nixosModules.sops

    ./boot
    ./core
    ./desktop
    ./misc
    ./networking
    ./presets
    ./programs
    ./services
    ./virtualisation

    ./hostinfo.nix
  ];
}
