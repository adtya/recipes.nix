{
  extensionPolicies ? { },
}:
let
  install = install_url: {
    inherit install_url;
    installation_mode = "force_installed";
  };
in
{
  DisableAppUpdate = true;
  DisableFirefoxAccounts = true;
  DisableFirefoxStudies = true;
  DisableFormHistory = true;
  DisablePocket = true;
  DisableTelemetry = true;
  DisplayBookmarksToolbar = "newtab";
  DontCheckDefaultBrowser = true;
  EnableTrackingProtection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    EmailTracking = true;
    Fingerprinting = true;
  };
  ExtensionSettings = {
    "*" = {
      installation_mode = "blocked";
      blocked_install_message = "Add the extension in your nix configuration to install it.";
    };
    "queryamoid@kaply.com" =
      install "https://github.com/mkaply/queryamoid/releases/download/v0.2/query_amo_addon_id-0.2-fx.xpi";
  } // extensionPolicies;
  FirefoxHome = {
    Search = true;
    TopSites = false;
    SponsoredTopSites = false;
    Highlights = false;
    Pocket = false;
    SponsoredPocket = false;
    Snippets = false;
    Locked = true;
  };
  FirefoxSuggest = {
    WebSuggestions = false;
    SponsoredSuggestions = false;
    ImproveSuggest = false;
    Locked = true;
  };
  Homepage = {
    StartPage = "previous-session";
    Locked = true;
  };
  NetworkPrediction = false;
  NewTabPage = false;
  NoDefaultBookmarks = true;
  OfferToSaveLogins = false;
  OverrideFirstRunPage = "";
  OverridePostUpdatePage = "";
  PasswordManagerEnabled = false;
  PrimaryPassword = false;
  SearchSuggestEnabled = false;
  UserMessaging = {
    WhatsNew = false;
    ExtensionRecommendations = false;
    FeatureRecommendations = false;
    UrlbarInterventions = false;
    SkipOnboarding = true;
    MoreFromMozilla = false;
    Locked = true;
  };
}
