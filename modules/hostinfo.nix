{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.hostinfo;
in
{
  options = {
    xyz.adtya.recipes.hostinfo = {
      hostname = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = "A name for the host";
      };
      local-ip = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "192.168.1.1";
        description = "Local IP of the host (optional. might be used by other modules)";
      };
      tailscale-ip = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "100.101.102.103";
        description = "Tailscale IP of the host (optional. might be used by other modules)";
      };
      public-ip = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "123.123.123.123";
        description = "Public IP of the host (optional. might be used by other modules)";
      };
    };
  };

  config = lib.mkIf (cfg.hostname != null) { networking.hostName = cfg.hostname; };
}
