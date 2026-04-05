{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.core.users;
  sops-cfg = config.xyz.adtya.recipes.core.sops;
in
{

  options = {
    xyz.adtya.recipes.core.users = {
      root-password-hash-file = lib.mkOption {
        type = lib.types.str;
        example = "/persist/secrets/root-password-hash";
        description = "Path to file containing passsword hash for root user";
      };
      primary = {
        name = lib.mkOption {
          type = lib.types.str;
          example = "john";
          description = "user name for the non-root primarty user";
        };
        password-hash-file = lib.mkOption {
          type = lib.types.str;
          example = "/persist/secrets/password-hash";
          description = "Path to file containing the user's password hash";
        };
        long-name = lib.mkOption {
          type = lib.types.str;
          example = "John Doe";
          description = "Longer version of the user's name";
        };
        extra-groups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "wheel" ];
          description = "Extra groups the user should be added to";
        };
        allowed-ssh-keys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "ssh-ed25519 blah blah" ];
          description = "List of ssh public keys that can log-in as this user";
        };
      };
    };
  };

  config = {
    sops = lib.mkIf sops-cfg.enable {
      secrets = {
        "${cfg.root-password-hash-file}" = {
          mode = "400";
          owner = config.users.users.root.name;
          inherit (config.users.users.root) group;
          neededForUsers = true;
        };
        "${cfg.primary.password-hash-file}" = {
          mode = "400";
          owner = config.users.users.root.name;
          inherit (config.users.users.root) group;
          neededForUsers = true;
        };
      };
    };
    users = {
      mutableUsers = false;
      users = {
        root = {
          hashedPasswordFile =
            if sops-cfg.enable then
              config.sops.secrets.${cfg.root-password-hash-file}.path
            else
              cfg.root-password-hash-file;
        };
        "${cfg.primary.name}" = {
          isNormalUser = true;
          uid = 1000;
          hashedPasswordFile =
            if sops-cfg.enable then
              config.sops.secrets.${cfg.primary.password-hash-file}.path
            else
              cfg.primary.password-hash-file;
          description = cfg.primary.long-name;
          shell = pkgs.zsh;
          extraGroups = cfg.primary.extra-groups;
          openssh.authorizedKeys.keys = cfg.primary.allowed-ssh-keys;
        };
      };
    };
  };
}
