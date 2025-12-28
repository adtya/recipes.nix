{ pkgs, nixpkgs }:
let
  nixos-minimal-do = pkgs.nixos {
    imports = [ "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix" ];
    system.stateVersion = "25.11";
  };
  docs = pkgs.callPackage ./docs.nix { };
in
{
  inherit (nixos-minimal-do) digitalOceanImage;
  docs-devserver = docs.devserver;
  docs-site = docs.site;
}
