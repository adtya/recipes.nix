{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.misc.devtools;
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
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      git.enable = true;
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
