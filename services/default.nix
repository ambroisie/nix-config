{ ... }:

{
  imports = [
    ./gitea.nix
    ./indexers.nix
    ./jellyfin.nix
    ./matrix.nix
    ./media.nix
    ./nextcloud.nix
    ./nginx.nix
    ./pirate.nix
    ./postgresql-backup.nix
    ./rss-bridge.nix
    ./sabnzbd.nix
    ./transmission.nix
  ];
}
