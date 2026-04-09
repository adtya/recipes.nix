{ pkgs }:
{
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      git
      age
      sops
      ssh-to-age
      nil
      mdbook
      disko
      nurl
    ];
  };
}
