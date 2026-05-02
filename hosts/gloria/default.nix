_: {
  imports = [ ./hardware ];

  xyz.adtya.recipes = {
    hostinfo = {
      tailscale-ip = "100.69.69.3";
    };

    core = {
      nix.use-nh = true;
    };

    desktop = {
      dm.flavour = "cosmic";
      addons = {
        hypridle.backlight = {
          display = "intel_backlight";
          keyboard = "tpacpi::kbd_backlight";
        };
      };
      hyprland = {
        enable = true;
        hdr = true;
        laptop-mode = true;
        backlight-device = "intel_backlight";
        extraConfig = ''
          monitorv2 {
            output = eDP-1
            mode = preferred
            position = 0x0
            scale = auto
            transform = 0
            supports_wide_color = 1
            supports_hdr = 1
            bitdepth = 10
          }

          monitorv2 {
            output = *
            mode = preferred
            position = auto-right
            scale = auto
            transform = 0
          }
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
  };
  services = {
    thermald.enable = true;
    upower.enable = true;
  };

  system.stateVersion = "26.05";
}
