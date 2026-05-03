{ pkgs, nixvim' }:
let
  docs = pkgs.callPackage ./docs.nix { };
in
{
  docs-devserver = docs.devserver;
  docs-site = docs.site;

  wallhaven = pkgs.callPackage ./packages/wallhaven { };
  nixvim = nixvim'.makeNixvimWithModule {
    inherit pkgs;
    module = import ./nixvim;
  };
}
