{ pkgs }:
{
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      disko
      dnscontrol
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
