{ lib, ... }:
{
  imports = [
    ./firefox
    ./ghostty
    ./mpv

    ./fonts.nix
    ./starship.nix
    ./zsh.nix
  ];

  programs = {
    git.enable = true;
    neovim = {
      enable = lib.mkDefault true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
