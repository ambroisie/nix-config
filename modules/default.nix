# Common modules
{ ... }:

{
  imports = [
    ./documentation.nix
    ./hardware
    ./home.nix
    ./language.nix
    ./media.nix
    ./nix.nix
    ./packages.nix
    ./sound.nix
    ./upower.nix
    ./users.nix
  ];
}
