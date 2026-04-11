{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  toml = pkgs.formats.toml { };
  tranquil-pds = lib.getExe inputs.tranquil-pds.package.${system}.default;
  tranquil-config = {
    server = {
      hostname = "pds.ironyofprivacy.org";
      host = config.xyz.adtya.recipes.hostinfo.tailscale-ip;

    };
    database = {
      url = "postgresql:///tranquil?host=/run/postgresql";
    };
  };
  tranquil-config-file = toml.generate "tranquil-pds.toml" cfg.tranquil-config;
in
{
  sops = {
    secrets = {
      "tranquil/environment_file" = {
        mode = "400";
        owner = config.services.matrix-continuwuity.user;
        inherit (config.services.matrix-continuwuity) group;
      };
    };
  };
  services.postgresql = {
    ensureDatabases = [ "tranquil" ];
    ensureUsers = [
      {
        name = "tranquil";
        ensureDBOwnership = true;
      }
    ];
  };
  systemd.services.tranquil-pds = {
    description = "Tranquil PDS";
    documentation = [ "https://tangled.org/tranquil.farm/tranquil-pds" ];
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [
      "network-online.target"
      "postgresql.service"
    ];
    requires = [ "postgresql.service" ];
    serviceConfig = {
      EnvironmentFile = [ config.sops.secrets."tranquil/environment_file".path ];
      DynamicUser = true;
      AmbientCapabilities = [ "" ];
      CapabilityBoundingSet = [ "" ];
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
      PrivateDevices = true;
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
      StateDirectory = "tranquil-pds";
      StateDirectoryMode = "0700";
      RuntimeDirectory = "tranquil-pds";
      RuntimeDirectoryMode = "0700";
      UMask = "0077";
      ExecStart = "${tranquil-pds} --config-file ${tranquil-config-file}";
      Restart = "on-failure";
      RestartSec = 10;
      StartLimitBurst = 5;
    };
  };
}
