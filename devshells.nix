{ pkgs }:
{
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      age
      disko
      dnscontrol
      git
      mdbook
      nurl
      pyinfra
      sops
      ssh-to-age
    ];
  };
}
