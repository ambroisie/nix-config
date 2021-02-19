{ ... }:
{
  programs.direnv = {
    enable = true;
    # A better `use_nix`
    enableNixDirenvIntegration = true;
  };
}
