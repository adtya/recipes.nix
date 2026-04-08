{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.xyz.adtya.recipes.misc.gaming;
  ntsync-uaccess = pkgs.writeTextFile {
    name = "ntsync-udev-rules";
    text = ''
      KERNEL=="ntsync", MODE="0660", TAG+="uaccess"
    '';
    destination = "/etc/udev/rules.d/70-ntsync.rules";
  };
in
{
  options = {
    xyz.adtya.recipes.misc.gaming = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable gaming stuff";
      };
      lutris = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install Lutris";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xyz.adtya.recipes.core.users.primary.extra-groups = [ "gamemode" ];

    environment = {
      systemPackages = lib.mkIf cfg.lutris [
        (pkgs.lutris.override {
          extraPkgs = p: [
            p.gamemode
            p.gamescope
            p.mangohud
            p.vulkan-tools
            p.wineWow64Packages.waylandFull
          ];
        })
      ];
    };

    programs = {
      gamemode = {
        enable = true;
        enableRenice = true;
        settings = {
          general = {
            inhibit_screensaver = 1;
            softrealtime = "on";
          };
        };
      };

      steam = {
        enable = true;
        extraPackages = with pkgs; [
          gamemode
          gamescope
          mangohud
          vulkan-tools
          wineWow64Packages.waylandFull
        ];
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };

    };

    services.udev.packages = [ ntsync-uaccess ];
  };
}
