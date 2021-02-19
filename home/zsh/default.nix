{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh"; # Don't clutter $HOME
    enableCompletion = true;

    history = {
      size = 50000;
      ignoreSpace = true;
      ignoreDups = true;
      share = true;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };

    plugins = with pkgs; [
      {
        name = "fast-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          sha256 = "sha256-DWVFBoICroKaKgByLmDEo4O+xo6eA8YO792g8t8R7kA=";
        };
      }
    ];

    # Modal editing is life, but CLI benefits from emacs gymnastics
    defaultKeymap = "emacs";

    initExtra = lib.concatMapStrings builtins.readFile [
      ./completion-styles.zsh
      ./options.zsh
    ];
  };

  # Fuzzy-wuzzy
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.dircolors = {
    enable = true;
  };
}
