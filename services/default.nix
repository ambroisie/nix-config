{ ... }:

{
  imports = [
    ./gitea.nix
    ./jellyfin.nix
    ./matrix.nix
    ./media.nix
    ./nginx.nix
    ./pirate.nix
    ./sabnzbd.nix
    ./transmission.nix
  ];
}
