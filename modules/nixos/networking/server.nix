{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.networking;
  server-cfg = config.xyz.adtya.recipes.presets.server;
  serverPreset = {
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
    networking = {
      firewall = {
        allowPing = true;
        logRefusedConnections = lib.mkDefault false;
      };
    };
    systemd = {
      services = {
        NetworkManager-wait-online.enable = false;
        systemd-networkd.stopIfChanged = false;
        systemd-resolved.stopIfChanged = false;
      };
      network = {
        enable = true;
        networks = {
          "20-virbr" = {
            matchConfig = {
              Name = "virbr*";
              Type = "bridge";
            };
            linkConfig = {
              Unmanaged = true;
            };
          };
          "21-docker" = {
            matchConfig = {
              Name = "docker*";
              Type = "bridge";
            };
            linkConfig = {
              Unmanaged = true;
            };
          };
          "22-veth" = {
            matchConfig = {
              Name = "veth*";
              Type = "ether";
            };
            linkConfig = {
              Unmanaged = true;
            };
          };
          "40-ether" = {
            enable = true;
            matchConfig = {
              Type = "ether";
            };
            networkConfig = {
              DHCP = "yes";
              IPv4Forwarding = "yes";
            };
            dhcpV4Config = {
              UseDomains = true;
              RouteMetric = 100;
            };
            ipv6AcceptRAConfig = {
              RouteMetric = 100;
            };
            linkConfig = {
              RequiredForOnline = "routable";
            };
          };
        };
      };
    };

    services.resolved = {
      settings = {
        Resolve = {
          DNS = "1.1.1.1#one.one.one.one";
          DNSOverTLS = "false";
          DNSSEC = "false";
          FallbackDNS = "";
          Domains = "~.";
        };
      };
    };
  };
in
{
  options = {
    xyz.adtya.recipes.networking = {
      preset = {
        server = lib.mkOption {
          type = lib.types.bool;
          default = server-cfg;
          defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.server](#xyzadtyarecipespresetsserver)";
          description = "Enable the server preset for networking";
        };
      };
    };
  };

  config = lib.mkIf cfg.preset.server serverPreset;
}
