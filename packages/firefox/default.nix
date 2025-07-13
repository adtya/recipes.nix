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
  lockPrefs = prefs: builtins.replaceStrings [ "user_pref(" ] [ "lockPref(" ] prefs;
  loadPrefs = fileName: builtins.readFile "${betterfox-src}/${fileName}.js";
  extraPrefs = ''
    ${lib.optionalString (!disableFastfox) (lockPrefs (loadPrefs "Fastfox"))}
    ${lib.optionalString (!disablePeskyfox) (lockPrefs (loadPrefs "Peskyfox"))}
    ${lib.optionalString (!disableSecurefox) (lockPrefs (loadPrefs "Securefox"))}
    ${lib.optionalString (!disableSmoothfox) (lockPrefs (loadPrefs "Smoothfox"))}
    ${builtins.readFile ./prefs.cfg}
  '';

in
firefoxPkg.override {
  extraPolicies = import ./policies.nix;
  inherit extraPrefs;
}
