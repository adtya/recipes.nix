{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.services.ssh;
in
{
  options = {
    xyz.adtya.recipes.services.ssh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable SSH server";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      hostKeys = [
        {
          path = "/persist/secrets/ssh/keys/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/persist/secrets/ssh/keys/ssh_host_rsa_key";
          type = "rsa";
          bits = "4096";
        }
      ];
    };
  };
}
