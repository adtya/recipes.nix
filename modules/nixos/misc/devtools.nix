{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.misc.devtools;
  user-cfg = config.xyz.adtya.recipes.core.users;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  options = {
    xyz.adtya.recipes.misc.devtools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable some dev tools";
      };
      git = {
        user-name = lib.mkOption {
          type = lib.types.str;
          default = user-cfg.primary.long-name;
          defaultText = lib.literalMD "[config.xyz.adtya.recipes.core.users.primary.long-name](#xyzadtyarecipescoreusersprimarylong-name)";
          description = "Name of git user";
        };
        user-email = lib.mkOption {
          type = lib.types.str;
          default = user-cfg.primary.email;
          defaultText = lib.literalMD "[config.xyz.adtya.recipes.core.users.primary.email](#xyzadtyarecipescoreusersprimaryemail)";
          description = "Email of git user";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      delta
      doctl
      flyctl
      gh
      hcloud
      ripgrep

    ];
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      git = {
        enable = true;
        config = {
          user = {
            email = cfg.git.user-email;
            name = cfg.git.user-name;
          };
          commit.verbose = true;
          core = {
            fsmonitor = true;
            pager = lib.getExe pkgs.delta;
            untrackedCache = true;
          };
          delta = {
            side-by-side = false;
            syntax-theme = "Dracula";
          };
          diff.algorithm = "histogram";
          feature.manyFiles = true;
          fetch.prune = true;
          init.defaultBranch = "main";
          interactive.diffFilter = "${lib.getExe pkgs.delta} --color-only";
          merge.conflictstyle = "zdiff3";
          pull.ff = "only";
          push = {
            autoSetupRemote = true;
            default = "current";
          };
        };
      };
      lazygit.enable = true;
      neovim = {
        enable = true;
        package = inputs.neovim-nightly.packages.${system}.default;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };
    };
  };
}
