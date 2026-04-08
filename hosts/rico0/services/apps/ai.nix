{ config, ... }:
{
  services.caddy.virtualHosts = {
    "ai.labs.adtya.xyz" = {
      listenAddresses = [ config.xyz.adtya.recipes.hostinfo.tailscale-ip ];
      extraConfig = ''
        import hetzner
        reverse_proxy 100.69.69.1:11434
      '';
    };
  };
}
