{ pkgs }:
{
  default = pkgs.mkShell { buildInputs = with pkgs; [ nil ]; };
}
