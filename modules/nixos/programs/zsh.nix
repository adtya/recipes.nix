{ lib, config, ... }:
let
  cfg = config.xyz.adtya.recipes.programs.zsh;
in
{
  options = {
    xyz.adtya.recipes.programs.zsh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = true;
        description = "Enable ZSH";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      fzf = {
        fuzzyCompletion = true;
        keybindings = true;
      };
      zoxide.enable = true;
      zsh = {
        enable = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        vteIntegration = true;
        interactiveShellInit = ''
          autoload edit-command-line
          zle -N edit-command-line
          bindkey -e '^Xe' edit-command-line
        '';
        shellAliases = {
          cp = "cp -v";
          grep = "grep --color=auto";
          ln = "ln -v";
          mv = "mv -v";
        };
        setOptions = [
          "HIST_EXPIRE_DUPS_FIRST"
          "EXTENDED_HISTORY"
          "HIST_IGNORE_DUPS"
          "HIST_IGNORE_ALL_DUPS"
          "HIST_IGNORE_SPACE"

          "NO_APPEND_HISTORY"
          "NO_HIST_SAVE_NO_DUPS"
          "NO_HIST_FIND_NO_DUPS"
          "NO_SHARE_HISTORY"
        ];
      };
    };
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
