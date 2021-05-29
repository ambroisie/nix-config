# Common modules
{ ... }:

{
  imports = [
    ./hardware
    ./home.nix
    ./nix.nix
    ./packages.nix
    ./services
    ./system
  ];
}
