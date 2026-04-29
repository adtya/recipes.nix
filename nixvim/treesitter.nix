{ config, ... }:
{
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
    folding.enable = false;
  };
  grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
    bash
    json
    lua
    markdown
    nix
    regex
    toml
    yaml
  ];
}
