_: {
  imports = [
    ./firefox
    ./ghostty

    ./fonts.nix
    ./starship.nix
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
