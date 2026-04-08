{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.jovian.nixosModules.default ];

  nixpkgs.overlays = [ inputs.jovian.overlays.default ];

  environment.systemPackages = with pkgs; [ steamdeck-firmware ];

  services.displayManager.enable = true;

  jovian = {
    devices.steamdeck = {
      autoUpdate = true;
      enable = true;
    };
    hardware.has.amd.gpu = true;
    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "gnome";
      user = config.xyz.adtya.recipes.core.users.primary.name;
    };
  };
}
