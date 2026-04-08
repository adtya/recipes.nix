{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  the-power-button = lib.getExe inputs.the-power-button.packages.${system}.default;
in
{
  services.caddy.virtualHosts = {
    "power.labs.adtya.xyz" = {
      listenAddresses = [ config.xyz.adtya.recipes.hostinfo.tailscale-ip ];
      extraConfig = ''
        import hetzner
        reverse_proxy 127.0.0.1:8081
      '';
    };
  };
  systemd.services.the-power-button = {
    description = "The Power Button Server";
    documentation = [ "https://codeberg.org/adtya/the-power-button" ];
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      DynamicUser = true;
      SupplementaryGroups = "dialout";

      AmbientCapabilities = [ "" ];
      CapabilityBoundingSet = [ "" ];
      DeviceAllow = [ "/dev/ttyACM0" ];
      DevicePolicy = "closed";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      PrivateDevices = false;
      PrivateMounts = true;
      PrivateTmp = true;
      PrivateUsers = true;
      PrivateIPC = true;
      RemoveIPC = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictSUIDSGID = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "@resources"
      ]
      ++ [
        "~@clock"
        "~@debug"
        "~@module"
        "~@mount"
        "~@reboot"
        "~@swap"
        "~@cpu-emulation"
        "~@obsolete"
        "~@timer"
        "~@chown"
        "~@setuid"
        "~@privileged"
        "~@keyring"
        "~@ipc"
      ];
      SystemCallErrorNumber = "EPERM";
      StateDirectory = "the-power-button";
      StateDirectoryMode = "0700";
      RuntimeDirectory = "the-power-button";
      RuntimeDirectoryMode = "0700";
      UMask = "0077";
      ExecStart = "${the-power-button} --http-listen 127.0.0.1:8081 --wol-target=192.168.1.255:9 --serial-device=/dev/ttyACM0";
      Restart = "on-failure";
      RestartSec = 10;
      StartLimitBurst = 5;
    };
  };
}
