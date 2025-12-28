## Add recipes.nix as an input

```nix
{
    ...
    inputs.recipes.url = "github:adtya/recipes.nix?ref=main";
    outputs = { recipes, ...}: {
        ...
    };
}
```

## Add the package overlay

```nix
nixpkgs.overlays = [ recipes.overlays.default ];
```

## Add the NixOS Module

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
