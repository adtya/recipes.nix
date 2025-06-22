{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.recipes.stk;
in
{
  options.recipes.stk = {
    enable = lib.mkEnableOption "SuperTuxKart Server";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.superTuxKart.overrideAttrs (
        _final: prev: { cmakeFlags = prev.cmakeFlags ++ [ "-DSERVER_ONLY=ON" ]; }
      );
    };
    configFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to STK server config file";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.stk-server = {
      description = "SuperTuxKart Server";
      documentation = [ "https://github.com/supertuxkart/stk-code" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        DynamicUser = true;
        AmbientCapabilities = [ "" ];
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
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
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter =
          [
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
        StateDirectory = "stk-server";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "stk-server";
        RuntimeDirectoryMode = "0700";
        UMask = "0077";
        ExecStart = "${lib.getExe cfg.package} --server-config=${cfg.configFile}";
        Restart = "on-failure";
        RestartSec = 10;
        StartLimitBurst = 5;
      };
    };
  };
}
