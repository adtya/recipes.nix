{ lib, ... }:
{
  options = {
    xyz.adtya.recipes.tailscale = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Tailscale";
      };
      net-name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "tail123456.ts.net";
        description = "The Tailnet DNS name from https://login.tailscale.com/admin/dns";
      };
      auth-file = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/run/secrets/tailscale_auth";
        description = "Path to a file containing Tailscale Auth key";
      };
    };
  };
}
