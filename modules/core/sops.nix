{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.core.sops;
in
{
  options = {
    xyz.adtya.recipes.core.sops = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable sops.nix for secret management";
      };
      secrets-file = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "./secrets.yaml";
        description = "Path to a file containing Tailscale Auth key.";
      };
    };
  };

  config = lib.mkIf cfg.enable { sops.defaultSopsFile = cfg.secrets-file; };
}
