{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.programs.starship;
in
{
  options = {
    xyz.adtya.recipes.programs.starship = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = true;
        description = "Enable Starship";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        git_metrics.disabled = false;
        nix_shell.disabled = true;
      };
    };
  };
}
