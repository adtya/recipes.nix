{ config, ... }:
let
  username = config.xyz.adtya.recipes.core.users.primary.name;
in
{
  environment.persistence."/persist/state" = {
    users."${username}" = {
      directories = [
        "Documents"
        "Downloads"
        "Games"
        "Others"
        "Projects"
        "Pictures"
        "Videos"

        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        ".steam"
        ".var"

        ".config/1Password"
        ".config/discord"
        ".config/easyeffects"
        ".config/doctl"
        ".config/gh"
        ".config/lazygit"
        ".config/mozilla"
        ".config/spotify"

        {
          directory = ".local/share/containers";
          mode = "0700";
        }
        ".local/share/direnv"
        ".local/share/flatpak"
        ".local/share/keyrings"
        ".local/share/nvim"
        ".local/share/nix"
        ".local/share/Steam"
        ".local/share/systemd"
        ".local/share/zsh"
        ".local/share/zoxide"

        ".local/state"
      ];
      files = [
        ".config/wallpaper_config.json"
        {
          file = ".config/sops/age/keys.txt";
          parentDirectory.mode = "0700";
        }
      ];
    };
  };
}
