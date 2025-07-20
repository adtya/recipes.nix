# Some Cool Nix Recipes

## Include in your flake
```nix
{
    ...
    inputs.recipes.url = "github:adtya/recipes.nix?ref=main";
    outputs = { recipes, ...}: {
        ...
    };
}
```

### Add the package overlay
```nix
nixpkgs.overlays = [ recipes.overlays.default ];
```

### Add the NixOS Module
```nix
nixosConfigurations.<hostname> = lib.nixosSystem {
    ...
    modules = [
       recipes.nixosModules.default
       ...
    ];
    ...
};
```
## Packages
### Firefox
This is a firefox derivation with the config I use on my personal machines, tweaked to be used by anyone in their NixOS, nix-darwin or home-manager configuration.

The changes include:
 - [Betterfox](https://github.com/yokoffing/BetterFox)
 - Policy tweaks to disable crap like telemetry, Firefox Account, etc. (refer [policies.nix](./packages/firefox/policies.nix) and [Policy Templates](https://mozilla.github.io/policy-templates) for details)
 - Vertical Sidebar (and tabs)
 - [Privacy Badger](https://privacybadger.org) and [uBlock Origin](https://ublockorigin.com) and installed
 - [Dracula](https://draculatheme.com/firefox) theme
 - and more ...


If the overlay is added as above, use `pkgs.firefox-overkill` instead of the typical `pkgs.firefox`. If the overlay is not added, use `inputs.recipes.packages.${pkgs.system}.firefox-overkill` instead.

All the [Betterfox](https://github.com/yokoffing/BetterFox) prefs are included. These can be disabled by setting one or more of:
```nix
firefox-overkill.override {
    disableFastfox = true;
    disablePeskyfox = true;
    disableSecurefox = true;
    disableSmoothfox = true;
};
```
The firefox distribution used can be changed by setting (This is not tested though. YMMV.):
```nix
firefox-overkill.override {
    firefoxPkg = pkgs.floorp-unwrapped; # or whatever your favorite distribution is.
};
```

Extensions can be added by setting:
```nix
firefox-overkill.override {
    extensions = [
        { id = "<extensions id from addons.mozilla.org>"; url = "<extension url>";
    ];
};
```
Use the [Query AMO ID](https://github.com/mkaply/queryamoid) extension (will be installed by default) to find extension ids when on the extension's AMO page.

## Modules
 coming soon ...

