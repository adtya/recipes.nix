{ pkgs }:
{
  autobrr = pkgs.callPackage ./packages/autobrr { };
  ezbookkeeping = pkgs.callPackage ./packages/ezbookkeeping { };
}
