{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  domainName = "adtya.xyz";
in
{
  services = {
    caddy.virtualHosts."${domainName}" = {
      serverAliases = [ "www.${domainName}" ];
      extraConfig = ''
        import hetzner
        handle {
          root ${inputs.adtyaxyz.packages.${system}.site}/
          encode gzip
          file_server
        }
        header {
          ?Cache-Control "max-age=86400"
        }
        handle_errors {
          rewrite /{err.status_code}.html
          file_server
        }
      '';
    };
  };
}
