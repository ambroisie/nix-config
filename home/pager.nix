{ ... }:
{
  programs.lesspipe.enable = true;

  home.sessionVariables = {
    # My default pager
    PAGER = "less";
    # Clear the screen on start and exit
    LESS = "-R -+X -c";
  };
}
