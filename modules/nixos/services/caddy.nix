{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.services.caddy;
  sops-cfg = config.xyz.adtya.recipes.core.sops;
in
{
  options = {
    xyz.adtya.recipes.services.caddy = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Caddy";
      };
      env-file = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "/persist/secrets/caddy/env";
        example = "/run/secrets/caddy_env";
        description = "Path to a file containing environment variables for the service";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops = lib.mkIf sops-cfg.enable {
      secrets = {
        "${cfg.env-file}" = {
          mode = "400";
          owner = config.users.users.root.name;
          inherit (config.users.users.root) group;
        };
      };
    };

    services.caddy = {
      enable = true;
      package = pkgs.caddy-hetzner;
      email = "admin@ironyofprivacy.org";
      extraConfig = ''
        (hetzner) {
          tls {
            dns hetzner {env.HETZNER_ACCESS_TOKEN}
            propagation_delay 30s
            resolvers 213.133.100.98
          }
        }
      '';
    };
    systemd.services.caddy = lib.mkIf config.services.caddy.enable {
      serviceConfig.EnvironmentFile =
        if sops-cfg.enable then config.sops.secrets.${cfg.env-file}.path else cfg.env-file;
      after = [
        "tailscaled.service"
        "tailscaled-autoconnect.service"
      ];
      unitConfig.Requires = [
        "tailscaled.service"
        "tailscaled-autoconnect.service"
      ];
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    networking.firewall.allowedUDPPorts = [
      80
      443
    ];
  };
}
