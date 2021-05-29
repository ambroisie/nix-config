# Common modules
{ ... }:

{
  imports = [
    ./documentation.nix
    ./hardware
    ./home.nix
    ./nix.nix
    ./packages.nix
    ./services
    ./system
  ];
}
