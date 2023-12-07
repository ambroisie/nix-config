# Google Cloudtop configuration
{ lib, pkgs, ... }:
{
  programs.git.package = lib.mkForce pkgs.emptyDirectory;

  services.gpg-agent.enable = lib.mkForce false;

  my.home = {
    tmux = {
      # I use scripts that use the passthrough sequence often on this host
      enablePassthrough = true;

      # HTerm uses `xterm-256color` as its `$TERM`, so use that here
      trueColorTerminals = [ "xterm-256color" ];
    };

    ssh = {
      mosh = {
        package = pkgs.emptyDirectory;
      };
    };
  };
}
