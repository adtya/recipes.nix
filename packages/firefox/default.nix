{
  pkgs,
  lib,
  firefoxPkg ? pkgs.firefox,
  disableFastfox ? false,
  disablePeskyfox ? false,
  disableSecurefox ? false,
  disableSmoothfox ? false,
}:
let
  betterfox-src = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "BetterFox";
    rev = "e66de491acd5e87f53abc3dfe9622f7ce5e2a101";
    hash = "sha256-Kkk3mqfQCXf/J+SoAKki46e4OoD6ZPHTlXT+yezj6gU=";
  };
  extraPrefs = ''
    ${builtins.readFile ./prefs.cfg}
    ${lib.optionalString (!disableFastfox) (builtins.readFile "${betterfox-src}/Fastfox.js")}
    ${lib.optionalString (!disablePeskyfox) (builtins.readFile "${betterfox-src}/Peskyfox.js")}
    ${lib.optionalString (!disableSecurefox) (builtins.readFile "${betterfox-src}/Securefox.js")}
    ${lib.optionalString (!disableSmoothfox) (builtins.readFile "${betterfox-src}/Smoothfox.js")}
  '';

in
firefoxPkg.override {
  extraPolicies = import ./policies.nix;
  inherit extraPrefs;
}
