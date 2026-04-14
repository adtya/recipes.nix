{ inputs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  domainName = "at.ironyofprivacy.org";
in
{
  services = {
    caddy.virtualHosts."${domainName}" = {
      serverAliases = [ "*.${domainName}" ];
      extraConfig = ''
        import hetzner
        root * ${inputs.tranquil-pds.packages.${system}.tranquil-frontend}
        request_body {
          max_size 10GB
        }
        reverse_proxy /xrpc/* http://127.0.0.1:3000 {
          flush_interval -1
          transport http {
            read_timeout 86400s
            write_timeout 86400s
          }
          header_up Host {host}
          header_up X-Real-IP {remote_host}
          header_up X-Forwarded-For {remote_host}
          header_up X-Forwarded-Proto {scheme}
          header_up Connection {>http.request.header.Connection}
          header_up Upgrade {>http.request.header.Upgrade}
        }

        reverse_proxy /oauth/ http://127.0.0.1:3000 {
          transport http {
            read_timeout 300s
            write_timeout 300s
          }
          header_up Host {host}
          header_up X-Real-IP {remote_host}
          header_up X-Forwarded-For {remote_host}
          header_up X-Forwarded-Proto {scheme}
        }

        reverse_proxy /.well-known/* http://127.0.0.1:3000 {
          header_up Host {host}
          header_up X-Real-IP {remote_host}
          header_up X-Forwarded-For {remote_host}
          header_up X-Forwarded-Proto {scheme}
        }

        reverse_proxy /webhook/* http://127.0.0.1:3000 {
          header_up Host {host}
          header_up X-Real-IP {remote_host}
          header_up X-Forwarded-For {remote_host}
          header_up X-Forwarded-Proto {scheme}
        }

        @simple_static_proxies path /metrics /health /robots.txt /logo
        reverse_proxy @simple_static_proxies http://127.0.0.1:3000 {
          header_up Host {host}
        }

        @didjson path_regexp didjson ^/u/[^/]+/did\.json$
        reverse_proxy @didjson http://127.0.0.1:3000 {
          header_up Host {host}
          header_up X-Real-IP {remote_host}
          header_up X-Forwarded-For {remote_host}
          header_up X-Forwarded-Proto {scheme}
        }

        handle /oauth-client-metadata.json {
          templates
          file_server
          header Content-Type "application/json"
        }

        handle /assets/* {
          try_files {path} =404
          header Cache-Control "public, immutable"
          file_server
        }

        handle /app/* {
          try_files {path} {path}/ /index.html
          file_server
        }

        handle / {
          try_files /homepage.html /index.html
          file_server
        }

        handle {
          try_files {path} {path}/ /index.html
          file_server
        }
      '';
    };
  };
}
