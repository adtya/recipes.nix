{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  smc-fonts = inputs.smc-fonts.packages.${system}.default;
  cfg = config.xyz.adtya.recipes.programs.fonts;
  preset-cfg = config.xyz.adtya.recipes.presets;
in
{
  options = {
    xyz.adtya.recipes.programs.fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.desktop;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
        description = "Setup fonts";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      fontconfig = {
        defaultFonts = {
          sansSerif = [
            "Adwaita Sans"
            "Manjari"
          ];
          serif = [
            "DejaVu Serif"
            "Manjari"
          ];
          monospace = [
            "Fira Code"
            "Symbols Nerd Font"
          ];
        };
        useEmbeddedBitmaps = true;
      };
      packages = with pkgs; [
        adwaita-fonts
        dejavu_fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        fira-code
        nerd-fonts.symbols-only
        (smc-fonts.override { fonts = [ "manjari" ]; })
      ];
    };
  };
}
