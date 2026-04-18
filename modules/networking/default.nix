{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.networking;
in
{
  imports = [
    ./desktop.nix
    ./server.nix
  ];
  options = {
    xyz.adtya.recipes.networking.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable networking";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      useDHCP = lib.mkDefault false;
      useNetworkd = true;
    };
    services.resolved = {
      enable = true;
      settings = {
        Resolve = {
          LLMNR = false;
          MulticastDNS = false;
        };
      };
    };
    systemd.network.wait-online.enable = false;
  };
}
