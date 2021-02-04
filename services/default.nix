{ ... }:

{
  imports = [
    ./gitea.nix
    ./jellyfin.nix
    ./matrix.nix
    ./media.nix
    ./nextcloud.nix
    ./nginx.nix
    ./pirate.nix
    ./postgresql-backup.nix
    ./sabnzbd.nix
    ./transmission.nix
  ];
}
