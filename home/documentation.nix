{ ... }:
{
  # Add documentation for user packages
  programs.man = {
    enable = true;
    generateCaches = true; # Enables the use of `apropos` etc...
  };
  programs.info.enable = true;
}
