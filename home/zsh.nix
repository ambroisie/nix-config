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

      # Style the completion a bit
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      # Show a prompt on selection
      zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
      # Use arrow keys in completion list
      zstyle ':completion:*' menu select
      # Group results by category
      zstyle ':completion:*' group-name ""
      # Keep directories and files separated
      zstyle ': completion:*' list-dirs-first true
      # Add colors to processes for kill completion
      zstyle ': completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

      # match uppercase from lowercase
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      # Filename suffixes to ignore during completion (except after rm command)
      zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro'

      # command for process lists, the local web server details and host completion
      # on processes completion complete all user processes
      zstyle ':completion:*:processes' command 'ps -au$USER'

      # Completion formatting and messages
      zstyle ':completion:*' verbose yes
      zstyle ':completion:*:descriptions' format '%B%d%b'
      zstyle ':completion:*:messages' format '%d'
      zstyle ':completion:*:warnings' format 'No matches for: %d'
      zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
    '';
  };

  # Fuzzy-wuzzy
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
