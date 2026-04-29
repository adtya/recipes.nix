{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nixvim.nixosModules.nixvim

    ./module.nix
  ];
}
