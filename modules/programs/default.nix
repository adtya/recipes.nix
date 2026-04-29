{ inputs, ... }:
{
  imports = [
    ./firefox
    ./ghostty

    ./fonts.nix
    ./starship.nix
    ./zsh.nix
  ];

  programs = {
    git.enable = true;
    nixvim = {
      enable = true;
      defaultEditor = true;
      imports = [ "${inputs.self}/nixvim" ];
    };
  };
}
