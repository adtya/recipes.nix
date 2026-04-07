_: {
  imports = [
    ./firefox

    ./fonts.nix
    ./starship.nix
    ./terminal.nix
    ./zsh.nix
  ];

  programs.git.enable = true;
}
