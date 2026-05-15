{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.programs.mpv;
  preset-cfg = config.xyz.adtya.recipes.presets;

  mpv-conf = ./mpv.conf;
  mpv-unwrapped = pkgs.mpv-unwrapped.overrideAttrs (
    _final: prev: {
      postInstall = prev.postInstall + ''
        rm $out/share/applications/umpv.desktop
      '';
    }
  );
  mpv-pkg = pkgs.mpv.override {
    inherit mpv-unwrapped;
    youtubeSupport = true;
    scripts = with pkgs.mpvScripts; [ mpris ];
  };
in
{
  options = {
    xyz.adtya.recipes.programs.mpv = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = preset-cfg.desktop;
        defaultText = lib.literalMD "[config.xyz.adtya.recipes.presets.desktop](#xyzadtyarecipespresetsdesktop)";
        description = "Enable MPV";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = mpv-pkg;
        description = "MPV package";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc."mpv/mpv.conf".source = mpv-conf;
      systemPackages = [ cfg.package ];
    };
  };
}
