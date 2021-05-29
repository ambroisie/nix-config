# Common modules
{ ... }:

{
  imports = [
    ./documentation.nix
    ./ergodox.nix
    ./hardware
    ./home.nix
    ./language.nix
    ./media.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./sound.nix
    ./upower.nix
    ./users.nix
  ];
}
