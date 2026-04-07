_: {
  imports = [
    ./firefox

    ./fonts.nix
    ./starship.nix
    ./terminal.nix
    ./zsh.nix
  ];

  programs = {
    git.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
