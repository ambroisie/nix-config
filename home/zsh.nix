{ config, pkgs, ... }:
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

    initExtra = ''
      # Show an error when a globbing expansion doesn't find any match
      setopt nomatch
      # List on ambiguous completion and Insert first match immediately
      setopt autolist menucomplete
      # Use pushd when cd-ing around
      setopt autopushd pushdminus pushdsilent
      # Use single quotes in string without the weird escape tricks
      setopt rcquotes
      # Single word commands can resume an existing job
      setopt autoresume
      # Those options aren't wanted
      unsetopt beep extendedglob notify
    '';
  };

  # Fuzzy-wuzzy
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
