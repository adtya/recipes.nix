{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.sops;
in
{
  imports = lib.mkIf cfg.enable [ inputs.sops-nix.nixosModules.sops ];
  config = lib.mkIf cfg.enable { sops.defaultSopsFile = cfg.secrets-file; };
}
