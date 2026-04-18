{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.virtualisation.containers;
in
{
  options = {
    xyz.adtya.recipes.virtualisation.containers = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable containers with podman";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers = {
        enable = true;
        containersConf.settings = {
          engine = {
            compose_providers = [ (lib.getExe pkgs.docker-compose) ];
            compose_warning_logs = false;
          };
        };
        registries.search = [ "docker.io" ];
      };
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings = {
          dns_enabled = true;
        };
      };
    };
    xyz.adtya.recipes = {
      core = {
        users.primary.extra-groups = [ "podman" ];
      };
    };
  };
}
