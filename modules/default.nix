# Common modules
{ ... }:

{
  imports = [
    ./hardware
    ./home.nix
    ./packages.nix
    ./services
    ./system
  ];
}
