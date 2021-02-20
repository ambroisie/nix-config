{ ... }:
{
  programs.tmux = {
    enable = true;

    clock24 = true; # I'm one of those heathens
    escapeTime = 0; # Let vim do its thing instead
    historyLimit = 5000; # Bigger buffer
  };
}
