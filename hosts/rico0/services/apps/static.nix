{ config, ... }:
{
  services.caddy.virtualHosts = {
    "static.labs.adtya.xyz" = {
      listenAddresses = [ config.xyz.adtya.recipes.hostinfo.tailscale-ip ];
      extraConfig = ''
        import hetzner
        root /persist/assets/
        encode gzip
        file_server
      '';
    };
  };

}
