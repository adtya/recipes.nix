{ lib, ... }:
{
  options = {
    xyz.adtya.recipes.nix = {
      auto-gc = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Automatic Garbage collection of the Nix store";
      };
      auto-optimise = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Automatic optimisation of the Nix store";
      };
    };
  };
}
