{ pkgs, ... }:
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
  };
}
