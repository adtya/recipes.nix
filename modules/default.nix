{ inputs, ... }:
{
  imports = [
    inputs.nixvim.nixosModules.nixvim
    inputs.sops-nix.nixosModules.sops

    ./module.nix
  ];
}
