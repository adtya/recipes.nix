{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  domainName = "nix-recipes.adtya.xyz";
in
{
  services = {
    caddy.virtualHosts."${domainName}" = {
      extraConfig = ''
        import hetzner
        handle {
          root ${inputs.self.packages.${system}.docs-site}/
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
