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

### Add NixOS Modules
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
1. Firefox
If the overlay is added as above, use `pkgs.firefox-overkill` instead of the typical `pkgs.firefox`. If the overlay is not added, use `inputs.recipes.packages.${pkgs.system}.firefox-overkill` instead.
By default, all the [Betterfox](https://github.com/yokoffing/BetterFox) prefs are included. These can be disabled by setting one or more of:
```nix
firefox-overkill.override {
    disableFastfox = true;
    disablePeskyfox = true;
    disableSecurefox = true;
    disableSmoothfox = true;
    };
```
The firefox distribution used can be changed by setting:
```nix
firefox-overkill.override {
    firefoxPkg = pkgs.floorp;
};
```
This is not tested though. YMMV.

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

