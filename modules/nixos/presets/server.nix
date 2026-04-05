{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.presets.server;
in
{
  options = {
    xyz.adtya.recipes.presets.server = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the server preset";
    };
  };

  config = lib.mkIf cfg { };
}
