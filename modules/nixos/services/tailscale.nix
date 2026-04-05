{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.services.tailscale;
  sops-cfg = config.xyz.adtya.recipes.core.sops;
in
{
  options = {
    xyz.adtya.recipes.services.tailscale = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Tailscale";
      };
      tailnet-name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "tail123456.ts.net";
        description = "The Tailnet DNS name from https://login.tailscale.com/admin/dns";
      };
      auth-file = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "/persist/secrets/tailscale/key";
        example = "/run/secrets/tailscale_auth";
        description = "Path to a file containing Tailscale Auth key";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops = lib.mkIf sops-cfg.enable {
      secrets = {
        "${cfg.auth-file}" = {
          mode = "400";
          owner = config.users.users.root.name;
          inherit (config.users.users.root) group;
        };
      };
    };

    services.tailscale = {
      enable = true;
      authKeyFile = if sops-cfg.enable then config.sops.secrets.${cfg.auth-file}.path else cfg.auth-file;
      openFirewall = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

    networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  };
}
