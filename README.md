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
    nixpkgs.overlays = [ inputs.recipes.overlays.default ];
```

### Add NixOS Modules
```nix
    nixosConfigurations.<hostname> = lib.nixosSystem {
        ...
        modules = [
            inputs.recipes.nixosModules.default
            ...
        ];
        ...
    };
```
## Packages
1. Firefox
If the overlay is added as above, use `pkgs.firefox-overkill` instead of the typical `pkgs.firefox`. If the overlay is not added, use `inputs.recipes.packages.${pkgs.system}.firefox-overkill` instead.

## Modules
 coming soon ...

