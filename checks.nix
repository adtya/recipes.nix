{
  pkgs,
  treefmt-nix,
  self,
}:
let
  treeFmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
in
{
  formatter = treeFmtEval.config.build.check self;
}
