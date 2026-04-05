## Add recipes.nix as an input

```nix
{
    ...
    inputs.recipes.url = "git+https://codeberg.org/adtya/recipes.nix?ref=main";
    outputs = inputs: {
        ...
    };
}
```

## Add the package overlay

```nix
nixpkgs.overlays = [ inputs.recipes.overlays.default ];
```

## Add the NixOS Module

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
