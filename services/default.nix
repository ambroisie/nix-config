{ ... }:

{
  imports = [
    ./gitea.nix
    ./jellyfin.nix
    ./matrix.nix
    ./media.nix
    ./nginx.nix
  ];
}
