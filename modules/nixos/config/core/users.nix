{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.core.users;
in
{
  config = {
    users = {
      mutableUsers = false;
      users = {
        root = {
          hashedPasswordFile = cfg.root-password-hash-file;
        };
        "${cfg.primary.name}" = {
          isNormalUser = true;
          uid = cfg.primary.id;
          hashedPasswordFile = cfg.primary.password-hash-file;
          description = cfg.primary.long-name;
          inherit (cfg.primary) shell;
          extraGroups = cfg.primary.extra-groups;
          openssh.authorizedKeys.keys = cfg.primary.allowed-ssh-keys;
        };
      };
    };
  };
}
