{ pkgs }:
{
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
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
