# Deployed services
{ config, ... }:
let
  my = config.my;
in
{
  # List services that you want to enable:
  my.services = {
    # Backblaze B2 backup
    backup = {
      enable = true;
      repository = "b2:porthos-backup";
      # Backup every 6 hours
      timerConfig = {
        OnActiveSec = "6h";
        OnUnitActiveSec = "6h";
      };
      # Insecure, I don't care.
      passwordFile =
        builtins.toFile "password.txt" my.secrets.backup.password;
      credentialsFile =
        builtins.toFile "creds.env" my.secrets.backup.credentials;
    };
    # Gitea forge
    gitea.enable = true;
    # Meta-indexers
    indexers = {
      jackett.enable = true;
      nzbhydra.enable = true;
    };
    # Jellyfin media server
    jellyfin.enable = true;
    # Matrix backend and Element chat front-end
    matrix = {
      enable = true;
      secret = my.secrets.matrix.secret;
    };
    # Nextcloud self-hosted cloud
    nextcloud = {
      enable = true;
      password = my.secrets.nextcloud.password;
    };
    # The whole *arr software suite
    pirate.enable = true;
    # Regular backups
    postgresql-backup.enable = true;
    # An IRC client daemon
    quassel.enable = true;
    # RSS provider for websites that do not provide any feeds
    rss-bridge.enable = true;
    # Usenet client
    sabnzbd.enable = true;
    # Because I stilll need to play sysadmin
    ssh-server.enable = true;
    # Torrent client and webui
    transmission = {
      enable = true;
      username = "Ambroisie";
      password = my.secrets.transmission.password;
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
