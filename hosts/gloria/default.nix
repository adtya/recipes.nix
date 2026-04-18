{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./hardware ];

  nix.settings = {
    extra-substituters = [
      "https://cache.soopy.moe"
      "https://t2linux.cachix.org"
    ];
    extra-trusted-substituters = [
      "https://cache.soopy.moe"
      "https://t2linux.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
      "t2linux.cachix.org-1:P733c5Gt1qTcxsm+Bae0renWnT8OLs0u9+yfaK2Bejw="
    ];
  };

  xyz.adtya.recipes = {
    boot.plymouth.theme = "owl";

    hostinfo = {
      host-name = "Gloria";
      tailscale-ip = "100.69.69.3";
    };

    core = {
      nix.use-nh = true;
    };

    desktop = {
      dm.flavour = "cosmic";
      hyprland = {
        enable = true;
        extraConfig = let
          brightnessctl = lib.getExe pkgs.brightnessctl;
        in ''
          input {
              touchpad {
              clickfinger_behavior = true
              disable_while_typing = true
              natural_scroll = true
              tap-to-click = true
            }
          }

          gestures {
            workspace_swipe = on
          }

          binde = ",XF86MonBrightnessUp,   exec, ${brightnessctl} --quiet --device=gmux_backlight set +5%"
          binde = ",XF86MonBrightnessDown, exec, ${brightnessctl} --quiet --device=gmux_backlight set 5%-"
        '';
      };
    };

    misc.devtools.enable = true;

    networking.wireless = false;

    presets = {
      desktop = true;
    };
  };

  networking.networkmanager.unmanaged = [ "mac:ac:de:48:00:11:22" ];

  services = {
    thermald.enable = true;
    auto-cpufreq = {
      enable = false;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };

  system.stateVersion = "26.05";
}
