{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.services.caddy;
  sops-cfg = config.xyz.adtya.recipes.core.sops;
  preset-cfg = config.xyz.adtya.recipes.presets;
  user-cfg = config.xyz.adtya.recipes.core.users;
in
{
  options = {
    xyz.adtya.recipes.services.caddy = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.server;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.server](#xyzadtyarecipespresetsserver)";
        description = "Enable Caddy";
      };
      env-file = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "/persist/secrets/caddy/env";
        description = "Path to a file containing environment variables for the service";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = user-cfg.primary.email;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.core.users.primary.email](#xyzadtyarecipescoreusersprimaryemail)";
        description = "Email used with ACME";
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
      inherit (cfg) email;
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

      after = lib.mkIf config.services.tailscale.enable [
        "tailscaled.service"
        "tailscaled-autoconnect.service"
      ];
      unitConfig.Requires = lib.mkIf config.services.tailscale.enable [
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
