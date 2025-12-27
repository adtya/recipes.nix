{ pkgs, nixpkgs }:
let
  nixos-minimal-do = pkgs.nixos {
    imports = [ "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix" ];
    system.stateVersion = "25.11";
  };
in
{
  inherit (nixos-minimal-do) digitalOceanImage;
  docs = pkgs.callPackage ./docs.nix { };
}
