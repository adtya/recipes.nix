{ pkgs }:
{
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      age
      git
      sops
      ssh-to-age
      nil
      mdbook
    ];
  };
}
