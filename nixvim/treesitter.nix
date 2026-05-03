{ config, ... }:
{
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
    folding.enable = false;
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      bash
      diff
      dockerfile
      git_config
      git_rebase
      gitattributes
      gitcommit
      gitignore
      hyprlang
      json
      lua
      markdown
      markdown_inline
      nix
      regex
      toml
      yaml
    ];
  };
}
