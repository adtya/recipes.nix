{ pkgs }:
{
  autobrr = pkgs.callPackage ./packages/autobrr { };
  ezbookkeeping = pkgs.callPackage ./packages/ezbookkeeping { };
  expenseowl = pkgs.callPackage ./packages/expenseowl { };
  firefox-overkill = pkgs.callPackage ./packages/firefox { };
}
