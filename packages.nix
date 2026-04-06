{ pkgs }:
let
  docs = pkgs.callPackage ./docs.nix { };
in
{
  docs-devserver = docs.devserver;
  docs-site = docs.site;
}
