{ pkgs, deploy-rs }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      age
      deploy-rs.packages.${system}.default
      git
      sops
      ssh-to-age
      nil
      mkdocs
      python3Packages.mkdocs-material
      python3Packages.pygments
    ];
  };
}
