{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.presets.server;
in
{
  options = {
    xyz.adtya.recipes.presets.server = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the server preset";
    };
  };

  config = lib.mkIf cfg {
    xyz.adtya.recipes.core.admin.needs-password = false;

    environment.systemPackages = with pkgs; [
      age
      sops
    ];
    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    programs = {
      command-not-found.enable = false;
    };

    systemd = {
      settings.Manager = {
        KExecWatchdogSec = "1m";
        RebootWatchdogSec = "30s";
        RuntimeWatchdogSec = "15s";
      };
      enableEmergencyMode = false;
      sleep.settings.Sleep = {
        AllowSuspend = "no";
        AllowHibernation = "no";
      };
    };

    virtualisation.oci-containers = {
      backend = "podman";
    };

    documentation = {
      enable = lib.mkDefault false;
      doc.enable = lib.mkDefault false;
      info.enable = lib.mkDefault false;
      man.enable = lib.mkDefault false;
      nixos.enable = lib.mkDefault false;
    };

    fonts.fontconfig.enable = lib.mkDefault false;

    xdg = {
      autostart.enable = lib.mkDefault false;
      icons.enable = lib.mkDefault false;
      mime.enable = lib.mkDefault false;
      sounds.enable = lib.mkDefault false;
      menus.enable = lib.mkDefault false;
    };
  };
}
