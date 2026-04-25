{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./hardware ];

  xyz.adtya.recipes = {
    boot.plymouth.theme = "owl";

    hostinfo = {
      tailscale-ip = "100.69.69.3";
    };

    core = {
      nix.use-nh = true;
    };

    desktop = {
      dm.flavour = "cosmic";
      hyprland = {
        enable = true;
        extraConfig =
          let
            brightnessctl = lib.getExe pkgs.brightnessctl;
          in
          ''
            input {
              touchpad {
                clickfinger_behavior = true
                disable_while_typing = true
                natural_scroll = true
                tap-to-click = true
              }
            }

            monitorv2 {
              output = eDP-1
              mode = preferred
              position = 0x0
              scale = 1.5
              transform = 0
            }

            monitorv2 {
              output = *
              mode = preferred
              position = auto-right
              scale = 1
              transform = 0
            }

            gesture = 3, horizontal, workspace

            binde = ,XF86MonBrightnessUp,   exec, ${brightnessctl} --quiet --device=intel_backlight set +5%
            binde = ,XF86MonBrightnessDown, exec, ${brightnessctl} --quiet --device=intel_backlight set 5%-
          '';
      };
    };

    misc = {
      bluetooth.enable = true;
      devtools.enable = true;
    };

    networking.wireless = false;

    presets = {
      desktop = true;
    };

    programs.waybar.laptop-mode = true;
  };

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
