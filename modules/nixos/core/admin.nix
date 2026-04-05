{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.core.admin;
in
{
  options = {
    xyz.adtya.recipes.core.admin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Make the primary non-root user the admin";
      };
      needs-password = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Ask for password when doing stuff as admin";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xyz.adtya.recipes = {
      core = {
        users.primary.extra-groups = [ "wheel" ];
      };
    };
    security = {
      polkit = {
        enable = true;
        adminIdentities = [ "unix-group:wheel" ];
        extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (subject.isInGroup("wheel")) {
              return ${if cfg.needs-password then "polkit.Result.AUTH_ADMIN_KEEP" else "polkit.Result.YES"};
            }
          });
        '';
      };
      run0 = {
        enableSudoAlias = true;
      };
      sudo.enable = !config.security.run0.enableSudoAlias;
    };
  };
}
