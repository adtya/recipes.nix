{
  config,
  pkgs,
  lib,
  ...
}:
let
  tailscaleInterface = config.services.tailscale.interfaceName;
  tailscaleIP = config.xyz.adtya.recipes.hostinfo.tailscale-ip;
  tailnetName = config.xyz.adtya.recipes.services.tailscale.tailnet-name;
  zoneFile = pkgs.replaceVars ./labs.adtya.xyz { inherit tailnetName tailscaleIP; };
in
{
  services.coredns = {
    enable = true;
    config = ''
      labs.adtya.xyz:53 {
        errors
        log stdout
        bind ${tailscaleInterface}
        file ${zoneFile}
      }
      ${tailnetName}:53 {
        errors
        log stdout
        bind ${tailscaleInterface}
        forward . 100.100.100.100:53
      }
    '';
  };
  systemd.services.coredns = lib.mkIf config.services.coredns.enable {
    after = lib.mkIf config.services.tailscale.enable [
      "tailscaled.service"
      "tailscaled-autoconnect.service"
    ];
    unitConfig = {
      Requires = lib.mkIf config.services.tailscale.enable [
        "tailscaled.service"
        "tailscaled-autoconnect.service"
      ];
      StartLimitIntervalSec = 0;
    };
    serviceConfig.RestartSec = "5s";
  };
}
