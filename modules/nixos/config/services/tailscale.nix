{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.services.tailscale;
  sops-cfg = config.xyz.adtya.recipes.core.sops;
in
{
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

    nodeconfig.facts.tailnet-name = cfg.tailnet-name;

    services.tailscale = {
      enable = true;
      authKeyFile = if sops-cfg.enable then config.sops.secrets.${cfg.auth-file}.path else cfg.auth-file;
      openFirewall = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

    networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  };
}
